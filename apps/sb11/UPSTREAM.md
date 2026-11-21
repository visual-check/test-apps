# Upstream

A copy of `apps/freecodecamp-ui` ([freeCodeCamp/ui](https://github.com/freeCodeCamp/ui) at
[`b0c467b`](https://github.com/freeCodeCamp/ui/tree/b0c467b97708cb71746f770fa1a0682711be1559), BSD-3-Clause, see
`LICENSE.md`, kept for its notice) upgraded to Storybook 11.0.0-beta.3. Renovate moves it to each newer Storybook 11
prerelease, then to 11's stable releases.

## Left out

- `.github/`: upstream's CI never runs from a subfolder.
- `renovate.json`: upstream's dependency updates don't apply to a pinned copy. This repository's `renovate.json` moves
  only this app's Storybook.

## Added for visual-check

- `visual-check.config.ts`: the config, with the `sb11` Storybook on port 6006.
- `.storybook/visual-check.ts`: the modes file `visual-check init` writes.
- `.visual-check/.gitignore`: keeps the baselines and nothing else visual-check writes.
- `test-app.json`: the build command, the Storybook's port and static build, and no addon (v1 has no addon on
  Storybook 11), for `scripts/setup-app.sh`.

Node 26 (`.nvmrc`) and pnpm 12.21.0 (`packageManager`) are upstream's. The visual-check packages are installed only at
run time and are never committed.

## Local changes

- `package.json` and `pnpm-lock.yaml`: `storybook`, `@storybook/react-vite`, `@storybook/react`,
  `@storybook/addon-docs` and `@storybook/addon-a11y` at 11.0.0-beta.3 in place of 10.6.7. Upstream's `.storybook`
  builds on 11 unchanged.

## Disabled stories

None.
