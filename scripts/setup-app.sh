#!/usr/bin/env bash
# Sets up the test app in the current folder for a visual-check run, as every CI job does before visual-check runs:
# loads the browser image, installs the packed visual-check packages with the app's own package manager, builds the
# app's Storybooks, serves each static build on its port in the background, and waits until each one answers.
#
# Usage, from an app's folder: ../../scripts/setup-app.sh <packages folder>
#
# The packages folder is visual-check's pack workflow artifact: each package's tarball as `pnpm pack` names it, such
# as visual-check-cli-0.0.0.tgz, and the browser image as chromium-image.tar.gz. The app's test-app.json names its
# build command, each Storybook's port and static build, and whether it takes the addon.
#
# Until visual-check#95 publishes the browser image and the browser package, the app installs the packed browser
# package, and its config names the loaded image through TEST_APPS_IMAGE, which this script hands to later steps
# through GITHUB_ENV.
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo 'Usage: setup-app.sh <packages folder>' >&2
  exit 2
fi

packages=$(cd "$1" && pwd)
tools=${RUNNER_TEMP:-${TMPDIR:-/tmp}}/test-apps-tools

# Upstream's git hooks would install into this repository's .git. Storybook's and Turborepo's telemetry would reach
# the network.
export HUSKY=0 SKIP_INSTALL_SIMPLE_GIT_HOOKS=1 STORYBOOK_DISABLE_TELEMETRY=1 TURBO_TELEMETRY_DISABLED=1
export COREPACK_ENABLE_DOWNLOAD_PROMPT=0

# Copies the one packed tarball of @visual-check/<name> into the app as .visual-check-packages/<name>.tgz.
copy_package() {
  local matches=("$packages/visual-check-$1-"[0-9]*.tgz)

  if [[ ${#matches[@]} -ne 1 || ! -f ${matches[0]} ]]; then
    echo "$packages holds no single packed @visual-check/$1." >&2
    exit 1
  fi

  cp "${matches[0]}" ".visual-check-packages/$1.tgz"
}

echo '::group::Load the browser image'
image=$(docker load --input "$packages/chromium-image.tar.gz" | sed -n 's/^Loaded image: //p' | tail -n 1)
if [[ -z $image ]]; then
  echo "docker load named no image from $packages/chromium-image.tar.gz." >&2
  exit 1
fi
if [[ -n ${GITHUB_ENV:-} ]]; then
  echo "TEST_APPS_IMAGE=$image" >> "$GITHUB_ENV"
else
  echo "Run visual-check with TEST_APPS_IMAGE=$image."
fi
echo '::endgroup::'

package_manager_spec=$(node -p "require('./package.json').packageManager.split('+')[0]")
package_manager=${package_manager_spec%%@*}

echo "::group::Install $package_manager_spec and http-server"
mkdir -p "$tools/bin"
if [[ $package_manager == bun ]]; then
  npm install --prefix "$tools" --no-audit --no-fund http-server@14.1.1 "$package_manager_spec"
else
  npm install --prefix "$tools" --no-audit --no-fund http-server@14.1.1 corepack@0.36.0
  "$tools/node_modules/.bin/corepack" enable --install-directory "$tools/bin"
fi
export PATH="$tools/bin:$tools/node_modules/.bin:$PATH"
echo '::endgroup::'

names=(cli chromium storybook)
if [[ $(node -p "require('./test-app.json').addon") == true ]]; then
  names+=(storybook-addon)
fi
mkdir -p .visual-check-packages
for name in "${names[@]}"; do
  copy_package "$name"
done

echo "::group::Install the app and the packed packages with $package_manager"
specs=()
case $package_manager in
  pnpm)
    for name in "${names[@]}"; do
      specs+=("./.visual-check-packages/$name.tgz")
    done
    pnpm add --save-dev --ignore-workspace-root-check "${specs[@]}"
    ;;
  yarn)
    for name in "${names[@]}"; do
      specs+=("@visual-check/$name@file:./.visual-check-packages/$name.tgz")
    done
    YARN_ENABLE_IMMUTABLE_INSTALLS=false yarn add --dev "${specs[@]}"
    ;;
  bun)
    for name in "${names[@]}"; do
      specs+=("./.visual-check-packages/$name.tgz")
    done
    # Bun resolves a peer dependency, such as @visual-check/cli's on @visual-check/chromium, from the registry even
    # when the same command adds it from a tarball. Overrides point every reference to the tarballs.
    # shellcheck disable=SC2016 # The template literals are JavaScript's.
    node -e '
      const fs = require("fs");
      const manifest = JSON.parse(fs.readFileSync("package.json", "utf8"));
      manifest.overrides ??= {};
      for (const name of process.argv.slice(1))
        manifest.overrides[`@visual-check/${name}`] = `file:./.visual-check-packages/${name}.tgz`;
      fs.writeFileSync("package.json", `${JSON.stringify(manifest, null, 2)}\n`);
    ' "${names[@]}"
    bun add --dev "${specs[@]}"
    ;;
  *)
    echo "The app uses $package_manager, which this script doesn't install with." >&2
    exit 1
    ;;
esac
echo '::endgroup::'

echo '::group::Build the Storybooks'
bash -c "$(node -p "require('./test-app.json').build")"
echo '::endgroup::'

ports=()
while read -r port static_dir; do
  http-server "$static_dir" -p "$port" -a 127.0.0.1 -s > "$tools/http-server-$port.log" 2>&1 &
  ports+=("$port")
done < <(node -e "for (const { port, staticDir } of require('./test-app.json').storybooks) console.log(port, staticDir)")

for port in "${ports[@]}"; do
  url="http://127.0.0.1:$port/index.json"
  for _ in $(seq 60); do
    if curl --silent --fail --output /dev/null "$url"; then
      echo "Serving $url"
      continue 2
    fi
    sleep 1
  done
  echo "Nothing answered at $url within 60 s:" >&2
  cat "$tools/http-server-$port.log" >&2
  exit 1
done
