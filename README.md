# visual-check test apps

## What this is

Real open-source projects that the [visual-check](https://github.com/visual-check/visual-check) packages about to be
published are installed and tested in. The spec is visual-check's
[`docs/prd/17-test-apps.md`](https://github.com/visual-check/visual-check/blob/main/docs/prd/17-test-apps.md).

## Apps

| Folder | Upstream | Pinned commit | License | Storybook | Package manager | Storybooks and ports | Stories | Disabled stories |
|---|---|---|---|---|---|---|---|---|
| `react-inspector` | storybookjs/react-inspector | `ae89c6c` | MIT | 9.1.4 | Yarn 4.17.1 | `react-inspector` on 9001 | 76 | none |
| `freecodecamp-ui` | freeCodeCamp/ui | `b0c467b` | BSD-3-Clause | 10.6.7 + addon | pnpm 12.21.0 | `freecodecamp-ui` on 6006 | 112 | none |

## A run

1. visual-check's pack workflow packs its packages from one commit and uploads them, with the browser image, as one
   artifact.
2. In each app's folder, `scripts/setup-app.sh <packages folder>` loads the image, installs the packed packages with
   the app's own package manager, builds the app's Storybooks and serves each one on its port.
3. The [visual-check Action](https://github.com/visual-check/action) runs visual-check against the served Storybooks.
4. The reusable workflow `.github/workflows/test-apps.yml` runs every app, and visual-check's CI calls it.
5. One app also runs inside a job container, as a project whose CI runs in a container would.

## Disabled stories

A story that breaks, or doesn't render the same way twice, gets `visualCheck({ disable: true })` in its stories file.
Each one is listed with its reason in the app's `UPSTREAM.md`. Every other story runs, with no filters.

## Interim browser package and image

Until [visual-check#95](https://github.com/visual-check/visual-check/issues/95) publishes them, each app installs the
packed `@visual-check/chromium`, and the browser image is loaded from the pack artifact. `scripts/setup-app.sh` names
the loaded image through `TEST_APPS_IMAGE`, which each app's config reads.

## Rewriting the baselines

## Running an app locally

## Licenses

Our own files are MIT (see `LICENSE`). `apps/*` keep their upstream licenses, all MIT or BSD-3-Clause, which is why
their baselines can be committed.
