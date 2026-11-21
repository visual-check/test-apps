# Upstream

[storybookjs/react-inspector](https://github.com/storybookjs/react-inspector) at
[`ae89c6c45b3f62573f01206fadcf051227572917`](https://github.com/storybookjs/react-inspector/tree/ae89c6c45b3f62573f01206fadcf051227572917),
MIT (see `LICENSE`).

## Left out

- `.github/`: upstream's CI never runs from a subfolder.

## Added for visual-check

- `visual-check.config.ts`: the config, with the `react-inspector` Storybook on port 9001.
- `.storybook/visual-check.ts`: the modes file `visual-check init` writes.
- `.visual-check/.gitignore`: keeps the baselines and nothing else visual-check writes.
- `test-app.json`: the build command, the Storybook's port and static build, and no addon, for `scripts/setup-app.sh`.
- `.nvmrc`: Node 24. Upstream names no Node version, and visual-check needs 22.17 or later.

The visual-check packages are installed only at run time and are never committed.

## Local changes

- `package.json`: `packageManager` is `yarn@4.17.1`, not `yarn@4.9.4`. Yarn 4.17.0 and earlier can't install
  `@visual-check/cli`: their builtin TypeScript patch fails on TypeScript 7, which the CLI depends on. 4.17.1 is the
  first Yarn that works, so the test apps cover the minimum. Installing with it rewrote `yarn.lock`'s metadata, and
  Yarn added to `.yarnrc.yml` the settings it writes when it upgrades a project: install scripts on, git dependencies
  allowed, and no minimum package age.

## Disabled stories

None.
