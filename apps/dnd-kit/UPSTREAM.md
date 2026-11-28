# Upstream

[clauderic/dnd-kit](https://github.com/clauderic/dnd-kit) at
[`ccaf3d583903a5d0b68616310a24aec891ee0d69`](https://github.com/clauderic/dnd-kit/tree/ccaf3d583903a5d0b68616310a24aec891ee0d69),
MIT (see `LICENSE`).

## Left out

- `.github/`: upstream's CI never runs from a subfolder.

Nothing else is left out: upstream's own `.gitignore` hides three of its tracked files,
`packages/{abstract,geometry,state}/.eslintrc.js`, so they're added with `git add -f`. A new copy must do the same.

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

- `apps/stories/stories/react/Sortable/Virtualized/Virtualized.stories.tsx`: the story under "Disabled stories" gets
  `parameters: { ...visualCheck({disable: true}) }`, and the file imports `visualCheck` from
  `../../../../.storybook/visual-check`.
- The stories under "Overflow allowed" get `visualCheck({allowOverflow: true})`: on the meta for the horizontal list
  files, whose every story overflows, and merged into the story's `parameters` for the multiple lists ones. Each file
  imports `visualCheck` from its Storybook's `.storybook/visual-check`.
- `packages/storybook-addon-codesandbox/src/preset.ts`: the manager entry's path comes from `fileURLToPath`. Upstream's
  `URL.pathname` is `/D:/…` on Windows, which isn't a path there.

## Disabled stories

### Too tall

The story renders all 1000 rows at 72 px each, so the page is 72,064 px tall, over Chromium's 32,767 px capture limit.
That's the story's own size, not a visual-check bug; it stays disabled.

| Storybook | Story ID | File | Reason | Message |
|---|---|---|---|---|
| `stories` | `react-sortable-virtualized--react-virtual` | `apps/stories/stories/react/Sortable/Virtualized/Virtualized.stories.tsx` | `too-tall` | The capture is 1280 × 72064 device pixels, over 32,767 on a side. |

## Overflow allowed

These stories show more than the 1280 px viewport is wide, so visual-check breaks them, `overflows`, unless they set
`allowOverflow`. The cut is upstream's layout, not a visual-check bug, and their baselines already are the page cut at
the viewport's right edge, so they set it and keep their baselines.

| Storybook | Stories | File | Content past the viewport's right edge |
|---|---|---|---|
| `stories` | every story of `react-sortable-horizontal-list` | `apps/stories/stories/react/Sortable/Horizontal/Horizontal.stories.tsx` | 16 to 1748 px: a horizontal list wider than the viewport |
| `stories` | `react-sortable-multiple-lists--example` | `apps/stories/stories/react/Sortable/MultipleLists/MultipleLists.stories.tsx` | 16 px |
| `stories-vanilla` | every story of `sortable-horizontal-list` | `apps/stories-vanilla/stories/Sortable/Horizontal/Horizontal.stories.ts` | 656 to 758 px |
| `stories-vue` | every story of `sortable-horizontal-list` | `apps/stories-vue/stories/Sortable/Horizontal/Horizontal.stories.ts` | 656 to 758 px |
| `stories-vue` | `sortable-multiple-lists--basic-setup` | `apps/stories-vue/stories/Sortable/MultipleLists/MultipleLists.stories.ts` | 16 px |
| `stories-solid` | every story of `sortable-horizontal-list` | `apps/stories-solid/stories/Sortable/Horizontal/Horizontal.stories.tsx` | 656 to 758 px |
| `stories-solid` | `sortable-multiple-lists--basic-setup` | `apps/stories-solid/stories/Sortable/MultipleLists/MultipleLists.stories.tsx` | 16 px |
| `stories-svelte` | every story of `sortable-horizontal-list` | `apps/stories-svelte/stories/Sortable/Horizontal/Horizontal.stories.ts` | 656 to 758 px |
| `stories-svelte` | `sortable-multiple-lists--basic-setup` | `apps/stories-svelte/stories/Sortable/MultipleLists/MultipleLists.stories.ts` | 16 px |
