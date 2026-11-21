# Upstream

[freeCodeCamp/ui](https://github.com/freeCodeCamp/ui) at
[`b0c467b97708cb71746f770fa1a0682711be1559`](https://github.com/freeCodeCamp/ui/tree/b0c467b97708cb71746f770fa1a0682711be1559),
BSD-3-Clause (see `LICENSE.md`, kept for its notice).

## Left out

- `.github/`: upstream's CI never runs from a subfolder.
- `renovate.json`: upstream's dependency updates don't apply to a pinned copy.

## Added for visual-check

- `visual-check.config.ts`: the config, with the `freecodecamp-ui` Storybook on port 6006.
- `.storybook/visual-check.ts`: the modes file `visual-check init` writes.
- `.visual-check/.gitignore`: keeps the baselines and nothing else visual-check writes.
- `test-app.json`: the build command, the Storybook's port and static build, and the addon, for
  `scripts/setup-app.sh`.

Node 26 (`.nvmrc`) and pnpm 12.21.0 (`packageManager`) are upstream's. The visual-check packages are installed only at
run time and are never committed.

## Local changes

- `.storybook/main.ts`: `@visual-check/storybook-addon` is registered after upstream's addons. Without the visual-check
  packages installed, Storybook warns that it can't resolve the addon, skips it and builds anyway.

## Disabled stories

None.
