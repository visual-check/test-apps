# Upstream

A copy of `apps/freecodecamp-ui` ([freeCodeCamp/ui](https://github.com/freeCodeCamp/ui) at
[`b0c467b`](https://github.com/freeCodeCamp/ui/tree/b0c467b97708cb71746f770fa1a0682711be1559), BSD-3-Clause, see
`LICENSE.md`, kept for its notice) upgraded to Storybook 11.0.0-beta.3. Renovate moves it to each newer Storybook 11
prerelease, then to 11's stable releases.

## Left out

- `.github/`: upstream's CI never runs from a subfolder.
- `renovate.json`: upstream's dependency updates don't apply to a pinned copy. This repository's `renovate.json` moves
  only this app's Storybook.

## Added for visual-check

- `visual-check.config.ts`: the config, with the `sb11` Storybook on port 6006.
- `.storybook/visual-check.ts`: the modes file `visual-check init` writes.
- `.visual-check/.gitignore`: keeps the baselines and nothing else visual-check writes.
- `test-app.json`: the build command, the Storybook's port and static build, and no addon (v1 has no addon on
  Storybook 11), for `scripts/setup-app.sh`.

Node 26 (`.nvmrc`) and pnpm 12.21.0 (`packageManager`) are upstream's. The visual-check packages are installed only at
run time and are never committed.

## Local changes

- `package.json` and `pnpm-lock.yaml`: `storybook`, `@storybook/react-vite`, `@storybook/react`,
  `@storybook/addon-docs` and `@storybook/addon-a11y` at 11.0.0-beta.3 in place of 10.6.7. Upstream's `.storybook`
  builds on 11 unchanged.
- `src/quiz-question/audio/audio.stories.tsx`, `src/quiz-question/quiz-question.stories.tsx` and
  `src/quiz/quiz.stories.tsx`: four stories are disabled for visual-check (see below).

## Disabled stories

These stories play an mp3 from `cdn.freecodecamp.org`. `src/quiz-question/audio/audio.tsx` shows the clip's duration
once its metadata arrives (`loadedmetadata`), which can be after the capture; visual-check never waits for the
network. The `with-audio-segment` stories set `finishTime`, show a fixed duration, and run. These stay disabled: the
stories depend on the network.

CI's first run broke the stories marked "yes". The other renders the same player and broke in a local `sb11` run.

| Storybook | Story ID | File | Reason | Message | Broke in CI |
|---|---|---|---|---|---|
| `sb11` | `internal-components-audio--default` | `src/quiz-question/audio/audio.stories.tsx` | `changed-after-capture` | doesn't render the same way twice | yes |
| `sb11` | `internal-components-audio--with-aria-label` | `src/quiz-question/audio/audio.stories.tsx` | `changed-after-capture` | doesn't render the same way twice | yes |
| `sb11` | `components-quiz--with-audio` | `src/quiz/quiz.stories.tsx` | `changed-after-capture` | doesn't render the same way twice | yes |
| `sb11` | `components-quizquestion--with-audio` | `src/quiz-question/quiz-question.stories.tsx` | `changed-after-capture` | doesn't render the same way twice | no, same player |
