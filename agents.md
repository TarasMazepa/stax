# Agents

## General
- Check [more-agents.md](more-agents.md) if present.
- Check [local-more-agents.md](local-more-agents.md) if present (overrides [agents.md](agents.md) and [more-agents.md](more-agents.md)).
- Check [tolooks.md](tolooks.md) if present.
- Check [docs/seeded/](docs/seeded/) if present; do not edit files there directly (propose changes in [repository-seed](https://github.com/TarasMazepa/repository-seed)).
- Keep project folder structure flat; avoid nested directories.
- Use pure `kebab-case` for all file and directory names (including markdown files like `readme.md`, `agents.md`, `more-agents.md`, `tolooks.md`) over `snake_case`, `camelCase`, or uppercase naming.
- Only use paths relative to home (`~` or `$HOME`) or relative to the project instead of hardcoded `/Users/<username>` paths.
- Reference and link source documents in documentation using only paths relative to the project or relative to home.
- Prefer `stax` over `git`/`gh` for git operations. Stax is available through brew `brew install TarasMazepa/stax/stax` on Linux and macOS and as `choco install stax` on Windows; see [docs/seeded/stax/agents.md](docs/seeded/stax/agents.md) or run the bash command `stax extras agents.md` for details.
- Open, update, or rebase PRs freely, but never merge PRs unless explicitly asked.

## ToLooks
- Maintain [tolooks.md](tolooks.md) as an exploratory scratchpad for backlog ideas, investigative spikes, architectural inquiries, and future refactors; see [docs/seeded/tolooks/readme.md](docs/seeded/tolooks/readme.md) for details.
- Record emerging ideas, potential optimizations, and discovered edge cases immediately in [tolooks.md](tolooks.md) to prevent scope creep during active tasks.
- Structure items with `Idea`, `Context`, and `Investigation` (or checklist).
- When resolving an item, mark it `[x]` with a concise `Resolution` summary, then prune [tolooks.md](tolooks.md) to keep it focused on active work: delete trivial or self-explanatory entries, and compact non-obvious architectural decisions or rejected alternatives (stripping stale investigation checklists) before moving them to `looked-at.md` (consult `looked-at.md` only when researching past decisions).
- Convert stalled or exploratory pull requests into ToLooks using [docs/seeded/tolooks/pr-to-tolook/SKILL.md](docs/seeded/tolooks/pr-to-tolook/SKILL.md) to preserve insights before closing.

## Dart
- One class per file when possible; do not use `interface class`.
- Prefer optional named arguments over positional optional arguments.
- Prefer `FutureOr<T>` (e.g., `FutureOr<void>`) when possible so client code can avoid `await` on the result.
- Use concrete types for mutable variables (no `var`); omit types on `final` and `const`.
- `toJson()` methods must return `dynamic`.
- Name extensions `On<Type>` matching the target type (e.g., `OnString`, `OnListOfLists`).
- Always run `dart pub get` before `dart format .` prior to pushing.

## GitHub Actions
- Match filename, workflow `name:`, and job ID: e.g. file `dart-format.yml` -> `name: dart-format.yml` -> job `dart-format`.
- Omit step `name` for `uses:` actions or single-line `run:` commands.

## Bash & Scripting
- Target macOS Bash 3.2 (POSIX tools like `awk` only; no `declare -A`, `mapfile`, or `coproc`).
- Scripts must work when invoked from any directory and print any provided commands on separate lines.
