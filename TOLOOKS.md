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

---

## Resolved Architectural Decisions

*(No resolved architectural decisions recorded yet.)*

---

## Related Documentation

- [AGENTS.md](AGENTS.md) — Agent guidelines and ToLooks rules.
- [docs/seeded/tolooks/README.md](docs/seeded/tolooks/README.md) — ToLooks concept and lifecycle guide.
