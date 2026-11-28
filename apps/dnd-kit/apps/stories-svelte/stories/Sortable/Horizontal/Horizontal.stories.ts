import type {Meta, StoryObj} from '@storybook/svelte-vite';

import HorizontalSortableApp from './HorizontalSortableApp.svelte';
import horizontalSortableSource from './HorizontalSortableApp.svelte?raw';
import horizontalSortableItemSource from './HorizontalSortableItem.svelte?raw';
import NestedScrollHorizontalSortableApp from './NestedScrollHorizontalSortableApp.svelte';
import {
  baseStyles,
  sortableStyles,
} from '@dnd-kit/stories-shared/styles/sandbox';
import {visualCheck} from '../../../.storybook/visual-check';

const meta: Meta = {
  title: 'Sortable/Horizontal list',
  parameters: {...visualCheck({allowOverflow: true})},
};

export default meta;
type Story = StoryObj;

export const BasicSetup: Story = {
  name: 'Basic setup',
  render: () => ({Component: HorizontalSortableApp}),
  parameters: {
    codesandbox: {
      files: {
        'src/App.svelte': horizontalSortableSource,
        'src/HorizontalSortableItem.svelte': horizontalSortableItemSource,
        'src/styles.css': [baseStyles, sortableStyles].join('\n\n'),
      },
    },
  },
};

export const NestedScroll: Story = {
  name: 'Nested scroll',
  render: () => ({Component: NestedScrollHorizontalSortableApp}),
};
