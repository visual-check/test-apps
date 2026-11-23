#!/usr/bin/env bash
# Runs visual-check on one test app from inside a WSL distro, as root. The app runs in the distro's own file system,
# where a project in WSL lives, and the report goes back to the Windows checkout.
#
# Usage, from the repository's root on the Windows drive: bash scripts/run-in-wsl.sh <app> <packages folder>
#
# The packages folder is what scripts/setup-app.sh takes.
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo 'Usage: run-in-wsl.sh <app> <packages folder>' >&2
  exit 2
fi

app=$1
packages=$(cd "$2" && pwd)
checkout=$PWD
copy=$HOME/test-apps

# Only Docker Desktop's engine takes the proxy. Any other engine in the distro would use host networking and pass.
engine=$(docker info --format '{{.OperatingSystem}}')
if [[ $engine != 'Docker Desktop' ]]; then
  echo "docker runs on $engine, not on Docker Desktop." >&2
  exit 1
fi

# Node's own tarball, checked against its SHASUMS256.txt.
node_version=24.22.3
node_sha256=061ec3e3062115705b56b51fa9cc330ab50d34b6969387d4e4b1a50c6809acc2
curl -fsSL --retry 5 -o /tmp/node.tar.gz "https://nodejs.org/dist/v$node_version/node-v$node_version-linux-x64.tar.gz"
echo "$node_sha256  /tmp/node.tar.gz" | sha256sum --check --strict
tar -xzf /tmp/node.tar.gz -C /usr/local --strip-components=1

mkdir -p "$copy/apps"
cp -r scripts "$copy/"
cp -r "apps/$app" "$copy/apps/"
cd "$copy/apps/$app"

# setup-app.sh hands TEST_APPS_IMAGE to later steps through the file GITHUB_ENV names.
GITHUB_ENV=$(mktemp)
export GITHUB_ENV
../../scripts/setup-app.sh "$packages"
set -a
# shellcheck disable=SC1090
source "$GITHUB_ENV"
set +a

status=0
./node_modules/.bin/visual-check test || status=$?
if [[ -d .visual-check/report ]]; then
  cp -r .visual-check/report "$checkout/apps/$app/.visual-check/"
fi
exit "$status"
