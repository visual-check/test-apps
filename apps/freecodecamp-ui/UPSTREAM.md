# Upstream

[freeCodeCamp/ui](https://github.com/freeCodeCamp/ui) at
[`b0c467b97708cb71746f770fa1a0682711be1559`](https://github.com/freeCodeCamp/ui/tree/b0c467b97708cb71746f770fa1a0682711be1559),
BSD-3-Clause (see `LICENSE.md`, kept for its notice).

## Left out

- `.github/`: upstream's CI never runs from a subfolder.
- `renovate.json`: upstream's dependency updates don't apply to a pinned copy.

## Added for visual-check

- `visual-check.config.ts`: the config, with the `freecodecamp-ui` Storybook on port 6006.
- `.storybook/visual-check.ts`: the modes file `visual-check init` writes.
- `.visual-check/.gitignore`: keeps the baselines and nothing else visual-check writes.
- `test-app.json`: the build command, the Storybook's port and static build, and the addon, for
  `scripts/setup-app.sh`.

Node 26 (`.nvmrc`) and pnpm 12.21.0 (`packageManager`) are upstream's. The visual-check packages are installed only at
run time and are never committed.

## Local changes

- `.storybook/main.ts`: `@visual-check/storybook-addon` is registered after upstream's addons. Without the visual-check
  packages installed, Storybook warns that it can't resolve the addon, skips it and builds anyway.
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
| `freecodecamp-ui` | `internal-components-audio--default` | `src/quiz-question/audio/audio.stories.tsx` | `changed-after-capture` | doesn't render the same way twice | yes |
| `freecodecamp-ui` | `internal-components-audio--with-aria-label` | `src/quiz-question/audio/audio.stories.tsx` | `changed-after-capture` | doesn't render the same way twice | yes |
| `freecodecamp-ui` | `components-quiz--with-audio` | `src/quiz/quiz.stories.tsx` | `changed-after-capture` | doesn't render the same way twice | yes |
| `freecodecamp-ui` | `components-quizquestion--with-audio` | `src/quiz-question/quiz-question.stories.tsx` | `changed-after-capture` | doesn't render the same way twice | no, same player |
