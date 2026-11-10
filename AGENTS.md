# Agents

## General
- Check [MORE-AGENTS.md](MORE-AGENTS.md) if present.
- Check [TOLOOKS.md](TOLOOKS.md) if present.
- Check [docs/from-seed/](docs/from-seed/) if present; do not edit files there directly (propose changes in [repository-seed](https://github.com/TarasMazepa/repository-seed)).
- Keep project folder structure flat; avoid nested directories.
- Prefer `kebab-case` over `snake_case`, `camelCase`, or other naming conventions.
- Only use paths relative to home (`~` or `$HOME`) or relative to the project instead of hardcoded `/Users/<username>` paths.
- Reference and link source documents in documentation using only paths relative to the project or relative to home.
- Prefer `stax` over `git`/`gh` for git operations. Stax is available through brew `brew install TarasMazepa/stax/stax` on Linux and macOS and as `choco install stax` on Windows; run the bash command `stax extras agents.md` for details.
- Open, update, or rebase PRs freely, but never merge PRs unless explicitly asked.

## ToLooks
- Maintain [TOLOOKS.md](TOLOOKS.md) as an exploratory scratchpad for backlog ideas, investigative spikes, architectural inquiries, and future refactors.
- Record emerging ideas, potential optimizations, and discovered edge cases immediately in [TOLOOKS.md](TOLOOKS.md) to prevent scope creep during active tasks.
- Structure items with `Idea`, `Context`, and `Investigation` (or checklist).
- When resolving an item, mark it `[x]` and document a concise `Resolution` summary so [TOLOOKS.md](TOLOOKS.md) acts as a lightweight architectural decision history.

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
