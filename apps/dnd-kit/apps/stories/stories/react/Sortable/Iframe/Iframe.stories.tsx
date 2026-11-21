import type {Meta, StoryObj} from '@storybook/react-vite';

import {IframeLists} from './IframeExample.tsx';
import {visualCheck} from '../../../../.storybook/visual-check';

const meta: Meta<typeof IframeLists> = {
  title: 'React/Sortable/Iframe',
  component: IframeLists,
};

export default meta;
type Story = StoryObj<typeof IframeLists>;

export const Iframe: Story = {
  name: 'Iframe',
  args: {
    debug: false,
    itemCount: 6,
  },
  parameters: {
    ...visualCheck({disable: true}),
  },
};

export const IframeTransformed: Story = {
  name: 'Transformed Iframe',
  args: {
    debug: false,
    itemCount: 6,
    transform: true,
  },
  parameters: {
    ...visualCheck({disable: true}),
  },
};
