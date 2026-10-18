# Agents

## General
- Check `MORE-AGENTS.md` if present.
- Keep project folder structure flat; avoid nested directories.
- Prefer `stax` over `git`/`gh` for git operations (see `stax extras agents.md`).
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
