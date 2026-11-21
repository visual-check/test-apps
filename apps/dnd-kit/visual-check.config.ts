import { defineConfig } from '@visual-check/cli'

/**
 * The browser image. Until visual-check's browser image is published (visual-check#95), a run loads one built from the
 * packed commit, and scripts/setup-app.sh names it here.
 */
const image = process.env.TEST_APPS_IMAGE

export default defineConfig({
  storybooks: {
    stories: { dir: 'apps/stories', url: 'http://127.0.0.1:6006' },
    'stories-vanilla': { dir: 'apps/stories-vanilla', url: 'http://127.0.0.1:6007' },
    'stories-vue': { dir: 'apps/stories-vue', url: 'http://127.0.0.1:6008' },
    'stories-solid': { dir: 'apps/stories-solid', url: 'http://127.0.0.1:6009' },
    'stories-svelte': { dir: 'apps/stories-svelte', url: 'http://127.0.0.1:6010' },
  },
  ...(image ? { image } : {}),
})
