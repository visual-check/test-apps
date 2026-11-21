import type {Meta, StoryObj} from 'storybook-solidjs';

import App from './DraggableApp';
import draggableSource from './DraggableApp.tsx?raw';
import {baseStyles, draggableStyles} from '@dnd-kit/stories-shared/styles/sandbox';
import {visualCheck} from '../../.storybook/visual-check';

const meta: Meta = {
  title: 'Draggable/Basic setup',
  component: App,
};

export default meta;
type Story = StoryObj;

export const Example: Story = {
  parameters: {
    ...visualCheck({disable: true}),
    codesandbox: {
      files: {
        'src/App.tsx': draggableSource,
        'src/styles.css': [baseStyles, draggableStyles].join('\n\n'),
      },
    },
  },
};
