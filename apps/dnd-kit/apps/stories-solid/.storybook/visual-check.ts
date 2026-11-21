import { defineVisualCheck } from '@visual-check/storybook'

// To set options for every story, spread visualCheck into the parameters in your preview file:
//   import { visualCheck } from './visual-check'
//   parameters: { ...visualCheck({}) },
export const visualCheck = defineVisualCheck({
  modes: {
    // Each mode a story lists adds one snapshot besides its default capture. For example:
    // mobile: { viewport: { width: 375, height: 667, deviceScaleFactor: 2, touch: true } },
  },
})
