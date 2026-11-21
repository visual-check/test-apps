import { defineConfig } from '@visual-check/cli'

/**
 * The browser image. Until visual-check's browser image is published (visual-check#95), a run loads one built from the
 * packed commit, and scripts/setup-app.sh names it here.
 */
const image = process.env.TEST_APPS_IMAGE

export default defineConfig({
  storybooks: {
    'react-inspector': { url: 'http://127.0.0.1:9001' },
  },
  ...(image ? { image } : {}),
})
