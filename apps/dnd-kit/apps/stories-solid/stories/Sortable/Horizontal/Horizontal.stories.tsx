import type {Meta, StoryObj} from 'storybook-solidjs';

import App from './HorizontalSortableApp';
import horizontalSortableSource from './HorizontalSortableApp.tsx?raw';
import {baseStyles, sortableStyles} from '@dnd-kit/stories-shared/styles/sandbox';
import {visualCheck} from '../../../.storybook/visual-check';

const meta: Meta = {
  title: 'Sortable/Horizontal list',
  parameters: {...visualCheck({allowOverflow: true})},
  component: App,
};

export default meta;
type Story = StoryObj;

export const BasicSetup: Story = {
  name: 'Basic setup',
  parameters: {
    codesandbox: {
      files: {
        'src/App.tsx': horizontalSortableSource,
        'src/styles.css': [baseStyles, sortableStyles].join('\n\n'),
      },
    },
  },
};

export const NestedScroll: Story = {
  name: 'Nested scroll',
  render: () => (
    <div style={{width: '100vw', 'overflow-x': 'auto', 'margin-left': '50vw'}}>
      <App />
    </div>
  ),
};
