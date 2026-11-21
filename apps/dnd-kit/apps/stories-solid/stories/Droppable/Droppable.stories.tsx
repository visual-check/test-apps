import type {Meta, StoryObj} from 'storybook-solidjs';

import App from './DroppableApp';
import droppableSource from './DroppableApp.tsx?raw';
import {baseStyles, draggableStyles, droppableStyles} from '@dnd-kit/stories-shared/styles/sandbox';
import {visualCheck} from '../../.storybook/visual-check';

const meta: Meta = {
  title: 'Droppable/Basic setup',
  component: App,
};

export default meta;
type Story = StoryObj;

export const Example: Story = {
  parameters: {
    ...visualCheck({disable: true}),
    codesandbox: {
      files: {
        'src/App.tsx': droppableSource,
        'src/styles.css': [baseStyles, draggableStyles, droppableStyles].join('\n\n'),
      },
    },
  },
};
