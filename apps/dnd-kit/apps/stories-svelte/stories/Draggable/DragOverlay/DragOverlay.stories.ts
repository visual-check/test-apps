import type {Meta, StoryObj} from '@storybook/svelte-vite';

import DragOverlayApp from './DragOverlayApp.svelte';
import dragOverlaySource from './DragOverlayApp.svelte?raw';
import draggableItemSource from './DraggableItem.svelte?raw';
import {
  baseStyles,
  draggableStyles,
} from '@dnd-kit/stories-shared/styles/sandbox';
import {visualCheck} from '../../../.storybook/visual-check';

const meta: Meta<typeof DragOverlayApp> = {
  title: 'Draggable/Drag overlay',
  component: DragOverlayApp,
};

export default meta;
type Story = StoryObj<typeof DragOverlayApp>;

export const Example: Story = {
  parameters: {
    ...visualCheck({disable: true}),
    codesandbox: {
      files: {
        'src/App.svelte': dragOverlaySource,
        'src/DraggableItem.svelte': draggableItemSource,
        'src/styles.css': [baseStyles, draggableStyles].join('\n\n'),
      },
    },
  },
};
