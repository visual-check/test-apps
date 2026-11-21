# Upstream

[clauderic/dnd-kit](https://github.com/clauderic/dnd-kit) at
[`ccaf3d583903a5d0b68616310a24aec891ee0d69`](https://github.com/clauderic/dnd-kit/tree/ccaf3d583903a5d0b68616310a24aec891ee0d69),
MIT (see `LICENSE`).

## Left out

- `.github/`: upstream's CI never runs from a subfolder.

## Storybooks

A monorepo with five Storybooks, each on upstream's own dev port:

| Storybook | Folder | Framework | Port |
|---|---|---|---|
| `stories` | `apps/stories` | React | 6006 |
| `stories-vanilla` | `apps/stories-vanilla` | HTML | 6007 |
| `stories-vue` | `apps/stories-vue` | Vue | 6008 |
| `stories-solid` | `apps/stories-solid` | Solid | 6009 |
| `stories-svelte` | `apps/stories-svelte` | Svelte | 6010 |

## Added for visual-check

- `visual-check.config.ts`: the config, with the five Storybooks above, each with its folder as `dir`.
- `.visual-check/.gitignore` here and in each Storybook's folder: keeps the baselines and nothing else visual-check
  writes. Each Storybook's baselines are in its own folder's `.visual-check/baselines`.
- `apps/<storybook>/.storybook/visual-check.ts`: the modes file `visual-check init` writes, one per Storybook.
- `test-app.json`: the build command (Turborepo builds the packages, then the five Storybooks), each Storybook's port
  and static build, and no addon, for `scripts/setup-app.sh`.

Bun 1.3.11 (`packageManager`) and Node 22 (`.nvmrc`) are upstream's. `22` resolves to the newest Node 22, which is past
the 22.17 visual-check needs. The visual-check packages are installed only at run time and are never committed.

## Local changes

None.

## Disabled stories

None.
