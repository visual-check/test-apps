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

- The stories files listed under "Disabled stories": each disabled story gets
  `parameters: { ...visualCheck({disable: true}) }`, and the file imports `visualCheck` from its Storybook's
  `.storybook/visual-check`.

## Disabled stories

### Animated icons

`apps/stories-shared/styles/sandbox.ts` draws `.btn::before` (a `background-image`) and `.droppable::after` (a
`content: url()`) as SVG data URLs whose `<animate>` repeats indefinitely, on a 4 s and a 3 s loop. visual-check doesn't
freeze SMIL animation in CSS images ([visual-check#143](https://github.com/visual-check/visual-check/issues/143)), so a
story that renders either icon passes or breaks depending on where the loop is at capture. They come back when #143 is
fixed.

CI's first run broke the stories marked "yes". The others render the same icon and are disabled before they flake: an
element whose computed `::before` `background-image` or `::after` `content` has `<animate>`, found by opening every
story of the five Storybooks in Chromium.

| Storybook | Story ID | File | Reason | Message | Broke in CI |
|---|---|---|---|---|---|
| `stories-solid` | `draggable-basic-setup--example` | `apps/stories-solid/stories/Draggable/Draggable.stories.tsx` | `changed-after-capture` | doesn't render the same way twice | yes |
| `stories-solid` | `draggable-drag-handles--example` | `apps/stories-solid/stories/Draggable/DragHandles/DragHandles.stories.tsx` | `changed-after-capture` | doesn't render the same way twice | yes |
| `stories-solid` | `droppable-basic-setup--example` | `apps/stories-solid/stories/Droppable/Droppable.stories.tsx` | `changed-after-capture` | doesn't render the same way twice | yes |
| `stories-solid` | `droppable-multiple-drop-targets--example` | `apps/stories-solid/stories/Droppable/MultipleDroppable/MultipleDroppable.stories.tsx` | `changed-after-capture` | doesn't render the same way twice | no, same icon |
| `stories-svelte` | `draggable-basic-setup--example` | `apps/stories-svelte/stories/Draggable/Draggable.stories.ts` | `changed-after-capture` | doesn't render the same way twice | yes |
| `stories-svelte` | `draggable-drag-handles--example` | `apps/stories-svelte/stories/Draggable/DragHandles/DragHandles.stories.ts` | `changed-after-capture` | doesn't render the same way twice | no, same icon |
| `stories-svelte` | `draggable-drag-overlay--example` | `apps/stories-svelte/stories/Draggable/DragOverlay/DragOverlay.stories.ts` | `changed-after-capture` | doesn't render the same way twice | no, same icon |
| `stories-svelte` | `droppable-basic-setup--example` | `apps/stories-svelte/stories/Droppable/Droppable.stories.ts` | `changed-after-capture` | doesn't render the same way twice | yes |
| `stories-svelte` | `droppable-multiple-drop-targets--example` | `apps/stories-svelte/stories/Droppable/MultipleDroppable/MultipleDroppable.stories.ts` | `changed-after-capture` | doesn't render the same way twice | yes |
| `stories-vanilla` | `draggable-basic-setup--example` | `apps/stories-vanilla/stories/Draggable/Draggable.stories.ts` | `changed-after-capture` | doesn't render the same way twice | yes |
| `stories-vanilla` | `draggable-drag-handle--example` | `apps/stories-vanilla/stories/Draggable/DragHandle/DragHandle.stories.ts` | `changed-after-capture` | doesn't render the same way twice | yes |
| `stories-vanilla` | `droppable-basic-setup--example` | `apps/stories-vanilla/stories/Droppable/Droppable.stories.ts` | `changed-after-capture` | doesn't render the same way twice | yes |
| `stories-vanilla` | `droppable-multiple-drop-targets--example` | `apps/stories-vanilla/stories/Droppable/MultipleDroppable/MultipleDroppable.stories.ts` | `changed-after-capture` | doesn't render the same way twice | yes |
| `stories-vue` | `draggable-basic-setup--example` | `apps/stories-vue/stories/Draggable/Draggable.stories.ts` | `changed-after-capture` | doesn't render the same way twice | yes |
| `stories-vue` | `draggable-drag-handles--example` | `apps/stories-vue/stories/Draggable/DragHandles/DragHandles.stories.ts` | `changed-after-capture` | doesn't render the same way twice | yes |
| `stories-vue` | `draggable-drag-overlay--example` | `apps/stories-vue/stories/Draggable/DragOverlay/DragOverlay.stories.ts` | `changed-after-capture` | doesn't render the same way twice | yes |
| `stories-vue` | `droppable-basic-setup--example` | `apps/stories-vue/stories/Droppable/Droppable.stories.ts` | `changed-after-capture` | doesn't render the same way twice | yes |
| `stories-vue` | `droppable-multiple-drop-targets--example` | `apps/stories-vue/stories/Droppable/MultipleDroppable/MultipleDroppable.stories.ts` | `changed-after-capture` | doesn't render the same way twice | yes |
| `stories` | `react-draggable--example` | `apps/stories/stories/react/Draggable/Draggable.stories.tsx` | `changed-after-capture` | doesn't render the same way twice | yes |
| `stories` | `react-draggable-drag-handles--drag-handle` | `apps/stories/stories/react/Draggable/DragHandles/DragHandles.stories.tsx` | `changed-after-capture` | doesn't render the same way twice | yes |
| `stories` | `react-draggable-drag-handles--dual-activators` | `apps/stories/stories/react/Draggable/DragHandles/DragHandles.stories.tsx` | `changed-after-capture` | doesn't render the same way twice | yes |
| `stories` | `react-draggable-drag-overlay--drag-overlay` | `apps/stories/stories/react/Draggable/DragOverlay/DragOverlay.stories.tsx` | `changed-after-capture` | doesn't render the same way twice | yes |
| `stories` | `react-draggable-modifiers--vertical-axis` | `apps/stories/stories/react/Draggable/Modifiers/Modifiers.stories.tsx` | `changed-after-capture` | doesn't render the same way twice | no, same icon |
| `stories` | `react-draggable-modifiers--horizontal-axis` | `apps/stories/stories/react/Draggable/Modifiers/Modifiers.stories.tsx` | `changed-after-capture` | doesn't render the same way twice | no, same icon |
| `stories` | `react-draggable-modifiers--window-modifier` | `apps/stories/stories/react/Draggable/Modifiers/Modifiers.stories.tsx` | `changed-after-capture` | doesn't render the same way twice | no, same icon |
| `stories` | `react-draggable-modifiers--container-modifier` | `apps/stories/stories/react/Draggable/Modifiers/Modifiers.stories.tsx` | `changed-after-capture` | doesn't render the same way twice | no, same icon |
| `stories` | `react-draggable-modifiers--snap-modifier-example` | `apps/stories/stories/react/Draggable/Modifiers/Modifiers.stories.tsx` | `changed-after-capture` | doesn't render the same way twice | yes |
| `stories` | `react-draggable-sensors--pointer` | `apps/stories/stories/react/Draggable/Sensors/Sensors.stories.tsx` | `changed-after-capture` | doesn't render the same way twice | yes |
| `stories` | `react-droppable--example` | `apps/stories/stories/react/Droppable/Droppable.stories.tsx` | `changed-after-capture` | doesn't render the same way twice | yes |
| `stories` | `react-droppable-multiple-drop-targets--example` | `apps/stories/stories/react/Droppable/MultipleDroppable/MultipleDroppable.stories.tsx` | `changed-after-capture` | doesn't render the same way twice | yes |

### Iframe transitions

These stories render their lists in a same-origin iframe. Once `@measured/auto-frame-component` copies the page's
styles in, CSS transitions run inside the iframe after capture, and visual-check doesn't settle them
([visual-check#144](https://github.com/visual-check/visual-check/issues/144)). They come back when #144 is fixed.

| Storybook | Story ID | File | Reason | Message |
|---|---|---|---|---|
| `stories` | `react-sortable-iframe--iframe` | `apps/stories/stories/react/Sortable/Iframe/Iframe.stories.tsx` | `changed-after-capture` | doesn't render the same way twice |
| `stories` | `react-sortable-iframe--iframe-transformed` | `apps/stories/stories/react/Sortable/Iframe/Iframe.stories.tsx` | `changed-after-capture` | doesn't render the same way twice |

### Too tall

The story renders all 1000 rows at 72 px each, so the page is 72,064 px tall, over Chromium's 32,767 px capture limit.
That's the story's own size, not a visual-check bug; it stays disabled.

| Storybook | Story ID | File | Reason | Message |
|---|---|---|---|---|
| `stories` | `react-sortable-virtualized--react-virtual` | `apps/stories/stories/react/Sortable/Virtualized/Virtualized.stories.tsx` | `too-tall` | The capture is 1280 × 72064 device pixels, over 32,767 on a side. |
