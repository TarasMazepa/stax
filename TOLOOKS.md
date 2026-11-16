# ToLooks

Exploratory scratchpad for backlog ideas, investigative spikes, architectural inquiries, and future refactors.

---

## Active ToLooks

- [ ] **1. Convert Stale PRs (>3 Months) Using `pr-to-tolook` Skill**
  - **Idea**: Review and convert open pull requests older than 3 months into structured ToLooks in `TOLOOKS.md` using the `pr-to-tolook` skill, then cleanly close the stale PRs after confirmation.
  - **Context**: As of 2026-11-14, 9 open PRs in `stax` have been hanging for more than 3 months (created before 2026-08-14), adding noise to health audits and accumulating merge drift.
  - **Investigation**:
    - [ ] [#1365](https://github.com/TarasMazepa/stax/pull/1365) [2026-07-24] *Add e2e benchmark for repositories with many merge commits*
    - [ ] [#1363](https://github.com/TarasMazepa/stax/pull/1363) [2026-07-22] *Add repository assertion helpers for e2e tests*
    - [ ] [#1171](https://github.com/TarasMazepa/stax/pull/1171) [2026-03-21] *Implement deterministic default remote and branch discovery algorithm*
    - [ ] [#1160](https://github.com/TarasMazepa/stax/pull/1160) [2026-03-21] *fix: improve stax rebase branch name matching to pick the shortest branch name*
    - [ ] [#892](https://github.com/TarasMazepa/stax/pull/892) [2025-08-04] *Winget release pipeline*
    - [ ] [#745](https://github.com/TarasMazepa/stax/pull/745) [2025-06-14] *added function to create permutations of commands*
    - [ ] [#675](https://github.com/TarasMazepa/stax/pull/675) [2025-05-19] *feat: nix flake which installs binary stax*
    - [ ] [#499](https://github.com/TarasMazepa/stax/pull/499) [2025-02-26] *browser extension - (Fetching List of PRs) - PR1 Fetching pr list api logic*
    - [ ] [#446](https://github.com/TarasMazepa/stax/pull/446) [2025-01-25] *browser extension - extension custom hostnames & codebase organize*

- [ ] **2. Investigate and Fix Failing GitHub Actions (`c2w-wasm.yml`, `cli-dart-test.yml`, `ui-flutter-test.yml`)**
  - **Idea**: Diagnose and fix the three failing GitHub Actions workflows observed on 2026-11-14/15 so CI and scheduled builds on `main` and SDK bump PRs are green.
  - **Context**:
    - `c2w-wasm.yml` (`schedule` on `main`, [run #43681031629](https://github.com/TarasMazepa/stax/actions/runs/43681031629)): Docker build fails with `404 Not Found` fetching `bullseye-security` `.deb` packages (`xz-utils`, `libcurl4`, `git`).
    - `cli-dart-test.yml` (`push` on `main`, [run #43631209456](https://github.com/TarasMazepa/stax/actions/runs/43631209456)): 39 passed, 1 failed (`test/cli/about_test.dart: about about`).
    - `ui-flutter-test.yml` (`pull_request` on `update-flutter-to-3.50.0-and-dart-to-3.14.0-2026-11-14T13-27-52`, [run #43599889302](https://github.com/TarasMazepa/stax/actions/runs/43599889302)): `flutter analyze` reported 2 issues.
  - **Investigation**:
    - [ ] Update `c2w-wasm.yml` base image or bust stale `apt-get update` cache so Debian security packages resolve cleanly.
    - [ ] Inspect and fix the assertion mismatch in `test/cli/about_test.dart`.
    - [ ] Resolve the 2 `flutter analyze` issues in the UI package for Flutter 3.50.0 / Dart 3.14.0.

---

- [ ] **3. Migrate Non-Kebab-Case Markdown Files to `kebab-case`**
  - **Idea**: Rename remaining uppercase/underscore markdown files to pure `kebab-case` per `agents.md` and update any internal or workflow references to them.
  - **Context**: `repository-seed` standardized markdown naming to pure `kebab-case` (`agents.md`, `readme.md`, `tolooks.md`, `more-agents.md`).
  - **Investigation**:
    - [ ] Rename `CHANGELOG.md` → `changelog.md` and update references
    - [ ] Rename `MORE-AGENTS.md` → `more-agents.md` and update references
    - [ ] Rename `README.md` → `readme.md` and update references
    - [ ] Rename `TOLOOKS.md` → `tolooks.md` and update references
    - [ ] Rename `ui/ios/Runner/Assets.xcassets/LaunchImage.imageset/README.md` → `ui/ios/Runner/Assets.xcassets/LaunchImage.imageset/readme.md` and update references

## Resolved Architectural Decisions

*(No resolved architectural decisions recorded yet.)*

---

## Related Documentation

- [AGENTS.md](AGENTS.md) — Agent guidelines and ToLooks rules.
- [docs/seeded/tolooks/README.md](docs/seeded/tolooks/README.md) — ToLooks concept and lifecycle guide.
