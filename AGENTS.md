# Agents

## General
- Check [more-agents.md](more-agents.md) if present.
- Keep project folder structure flat; avoid nested directories.
- Prefer `kebab-case` over `snake_case`, `camelCase`, or other naming conventions.
- Only use paths relative to home (`~` or `$HOME`) or relative to the project instead of hardcoded `/Users/<username>` paths.
- Reference and link source documents in documentation using only paths relative to the project or relative to home.
- Prefer `stax` over `git`/`gh` for git operations. Stax is available through brew `brew install TarasMazepa/stax/stax` on Linux and macOS and as `choco install stax` on Windows; run the bash command `stax extras agents.md` for details.
- Open, update, or rebase PRs freely, but never merge PRs unless explicitly asked.

## Dart
- One class per file when possible; do not use `interface class`.
- Prefer optional named arguments over positional optional arguments.
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
