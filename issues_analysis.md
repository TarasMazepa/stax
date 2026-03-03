# Stax Open Issues Analysis

This document provides a detailed analysis of the open issues in the `TarasMazepa/stax` repository.
It evaluates description detail levels, identifies missing context, estimates complexity, and provides a **highly specific, context-aware implementation plan** for issues with detailed descriptions.

## [#1056] High level directions for stax
**Link:** https://github.com/TarasMazepa/stax/issues/1056

### Analysis
- **Description Detail Level:** Medium (Approx. 458 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Update the README.md and documentation guides to reflect the new high-level directions for the `stax` project (incorporating git integration, CLI robustness, and UI goals).
2. **Scope:** Modifying `README.md` and creating a new guide in `guides/` outlining the project's roadmap and architecture.
3. **Execution:** Review recent commits and project discussions to summarize the project's direction. Draft the updates in markdown format.
4. **Verification:** Ensure all markdown links are valid and the documentation builds correctly if using a static site generator.
---

## [#1051] stax get - avoid getting if remote are local are the same
**Link:** https://github.com/TarasMazepa/stax/issues/1051

### Analysis
- **Description Detail Level:** Low (Approx. 0 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description is extremely sparse or missing entirely. Needs more context, use cases, or reproduction steps before work can begin.

### Implementation Plan
1. **Investigation Required:** The issue description lacks sufficient detail to formulate a specific implementation plan.
2. **Next Steps:**
   - Reach out to the author or maintainers to gather more context, reproduce steps, and clarify the expected behavior.
   - Once requirements are defined, identify the relevant components in `cli/` or `ui/` based on the issue title.
---

## [#1050] stax move head - will try to checkout remote ref when local and remote head are out of sync
**Link:** https://github.com/TarasMazepa/stax/issues/1050

### Analysis
- **Description Detail Level:** Low (Approx. 0 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description is extremely sparse or missing entirely. Needs more context, use cases, or reproduction steps before work can begin.

### Implementation Plan
1. **Investigation Required:** The issue description lacks sufficient detail to formulate a specific implementation plan.
2. **Next Steps:**
   - Reach out to the author or maintainers to gather more context, reproduce steps, and clarify the expected behavior.
   - Once requirements are defined, identify the relevant components in `cli/` or `ui/` based on the issue title.
---

## [#1047] stax receipts - a cappability to write a crossplatform bash script and share it with people
**Link:** https://github.com/TarasMazepa/stax/issues/1047

### Analysis
- **Description Detail Level:** Low (Approx. 0 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description is extremely sparse or missing entirely. Needs more context, use cases, or reproduction steps before work can begin.

### Implementation Plan
1. **Investigation Required:** The issue description lacks sufficient detail to formulate a specific implementation plan.
2. **Next Steps:**
   - Reach out to the author or maintainers to gather more context, reproduce steps, and clarify the expected behavior.
   - Once requirements are defined, identify the relevant components in `cli/` or `ui/` based on the issue title.
---

## [#1046] maybe hide some commands under another command
**Link:** https://github.com/TarasMazepa/stax/issues/1046

### Analysis
- **Description Detail Level:** Low (Approx. 94 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Reorganize the CLI command structure to nest less frequently used commands under appropriate parent groups (e.g., `stax git <subcommand>` or `stax util <subcommand>`).
2. **Scope:** Modifying the command registry in `cli/bin/stax.dart` and the individual command classes in `cli/lib/commands/`.
3. **Execution:**
   - Identify candidate commands for grouping based on usage metrics or logical grouping.
   - Refactor the `Command` classes in `cli/lib/commands/` to inherit from a `CommandGroup` or update the `args` parser to handle nested subcommands.
   - Update help text and documentation to reflect the new structure.
4. **Verification:** Run the CLI test suite (`dart test cli/`) to ensure argument parsing and command execution still function correctly for both top-level and nested commands.
---

## [#1045] add a changelog command
**Link:** https://github.com/TarasMazepa/stax/issues/1045

### Analysis
- **Description Detail Level:** Low (Approx. 0 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description is extremely sparse or missing entirely. Needs more context, use cases, or reproduction steps before work can begin.

### Implementation Plan
1. **Investigation Required:** The issue description lacks sufficient detail to formulate a specific implementation plan.
2. **Next Steps:**
   - Reach out to the author or maintainers to gather more context, reproduce steps, and clarify the expected behavior.
   - Once requirements are defined, identify the relevant components in `cli/` or `ui/` based on the issue title.
---

## [#1037] stax rebase branch name matching is very bad, it would pick a first branch that matches the prefix
**Link:** https://github.com/TarasMazepa/stax/issues/1037

### Analysis
- **Description Detail Level:** Medium (Approx. 108 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Improve the branch name matching logic in the `stax rebase` command to prevent it from greedily picking the first branch that matches a given prefix.
2. **Scope:** Modifying the branch resolution logic, likely found in `cli/lib/commands/rebase_command.dart` or a shared utility like `cli/lib/context/context_git_branch.dart`.
3. **Execution:**
   - Locate the function responsible for matching branch names against user input.
   - Update the matching algorithm to prioritize exact matches, or require a higher similarity score using a library like `string_similarity`.
   - Implement logic to handle ambiguous matches by prompting the user to select the correct branch from a list if multiple branches match the prefix equally well.
4. **Verification:** Add specific unit tests in `cli/test/commands/rebase_command_test.dart` to verify that exact matches are preferred over prefix matches and that ambiguous cases are handled gracefully.
---

## [#1036] stax rebase - will offer --abort instead of abandon
**Link:** https://github.com/TarasMazepa/stax/issues/1036

### Analysis
- **Description Detail Level:** Low (Approx. 0 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description is extremely sparse or missing entirely. Needs more context, use cases, or reproduction steps before work can begin.

### Implementation Plan
1. **Investigation Required:** The issue description lacks sufficient detail to formulate a specific implementation plan.
2. **Next Steps:**
   - Reach out to the author or maintainers to gather more context, reproduce steps, and clarify the expected behavior.
   - Once requirements are defined, identify the relevant components in `cli/` or `ui/` based on the issue title.
---

## [#1035] stax rebase - would choose not main branch to rebase onto
**Link:** https://github.com/TarasMazepa/stax/issues/1035

### Analysis
- **Description Detail Level:** Low (Approx. 0 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description is extremely sparse or missing entirely. Needs more context, use cases, or reproduction steps before work can begin.

### Implementation Plan
1. **Investigation Required:** The issue description lacks sufficient detail to formulate a specific implementation plan.
2. **Next Steps:**
   - Reach out to the author or maintainers to gather more context, reproduce steps, and clarify the expected behavior.
   - Once requirements are defined, identify the relevant components in `cli/` or `ui/` based on the issue title.
---

## [#1034] output log as a parsable content, json, or something else. so other tools could get it and represent in a different way
**Link:** https://github.com/TarasMazepa/stax/issues/1034

### Analysis
- **Description Detail Level:** Low (Approx. 0 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description is extremely sparse or missing entirely. Needs more context, use cases, or reproduction steps before work can begin.

### Implementation Plan
1. **Investigation Required:** The issue description lacks sufficient detail to formulate a specific implementation plan.
2. **Next Steps:**
   - Reach out to the author or maintainers to gather more context, reproduce steps, and clarify the expected behavior.
   - Once requirements are defined, identify the relevant components in `cli/` or `ui/` based on the issue title.
---

## [#1030] stax rebase and amend - make --prefer-moving a default flag
**Link:** https://github.com/TarasMazepa/stax/issues/1030

### Analysis
- **Description Detail Level:** Medium (Approx. 386 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Change the default behavior of the `stax rebase` and `stax amend` commands to automatically use the `--prefer-moving` flag.
2. **Scope:** Modifying the argument parsing configuration in `cli/lib/commands/rebase_command.dart` and `cli/lib/commands/amend_command.dart`.
3. **Execution:**
   - Locate the `ArgParser` setup for both commands.
   - Find the `--prefer-moving` flag definition and change its default value to `true`.
   - Update the help text for the flag to indicate that it is now enabled by default and consider adding a `--no-prefer-moving` flag to allow users to opt-out.
4. **Verification:** Update the corresponding unit tests to reflect the new default behavior and ensure that the `--no-prefer-moving` flag (if added) correctly disables the behavior.
---

## [#1029] stax pull - add a flag which will allow you to stay at main branch after pull
**Link:** https://github.com/TarasMazepa/stax/issues/1029

### Analysis
- **Description Detail Level:** Low (Approx. 0 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description is extremely sparse or missing entirely. Needs more context, use cases, or reproduction steps before work can begin.

### Implementation Plan
1. **Investigation Required:** The issue description lacks sufficient detail to formulate a specific implementation plan.
2. **Next Steps:**
   - Reach out to the author or maintainers to gather more context, reproduce steps, and clarify the expected behavior.
   - Once requirements are defined, identify the relevant components in `cli/` or `ui/` based on the issue title.
---

## [#1028] add stax help page to website, so help could be indexed same thing for change log
**Link:** https://github.com/TarasMazepa/stax/issues/1028

### Analysis
- **Description Detail Level:** Low (Approx. 0 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description is extremely sparse or missing entirely. Needs more context, use cases, or reproduction steps before work can begin.

### Implementation Plan
1. **Investigation Required:** The issue description lacks sufficient detail to formulate a specific implementation plan.
2. **Next Steps:**
   - Reach out to the author or maintainers to gather more context, reproduce steps, and clarify the expected behavior.
   - Once requirements are defined, identify the relevant components in `cli/` or `ui/` based on the issue title.
---

## [#1027] add a flag to commit to move back to the ref on which user was before running commit
**Link:** https://github.com/TarasMazepa/stax/issues/1027

### Analysis
- **Description Detail Level:** Low (Approx. 0 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description is extremely sparse or missing entirely. Needs more context, use cases, or reproduction steps before work can begin.

### Implementation Plan
1. **Investigation Required:** The issue description lacks sufficient detail to formulate a specific implementation plan.
2. **Next Steps:**
   - Reach out to the author or maintainers to gather more context, reproduce steps, and clarify the expected behavior.
   - Once requirements are defined, identify the relevant components in `cli/` or `ui/` based on the issue title.
---

## [#1026] add ability to open PR as a draft when running commit
**Link:** https://github.com/TarasMazepa/stax/issues/1026

### Analysis
- **Description Detail Level:** Low (Approx. 0 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description is extremely sparse or missing entirely. Needs more context, use cases, or reproduction steps before work can begin.

### Implementation Plan
1. **Investigation Required:** The issue description lacks sufficient detail to formulate a specific implementation plan.
2. **Next Steps:**
   - Reach out to the author or maintainers to gather more context, reproduce steps, and clarify the expected behavior.
   - Once requirements are defined, identify the relevant components in `cli/` or `ui/` based on the issue title.
---

## [#1025] add global --log flag which will output log after finishing running requested command
**Link:** https://github.com/TarasMazepa/stax/issues/1025

### Analysis
- **Description Detail Level:** Low (Approx. 0 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description is extremely sparse or missing entirely. Needs more context, use cases, or reproduction steps before work can begin.

### Implementation Plan
1. **Investigation Required:** The issue description lacks sufficient detail to formulate a specific implementation plan.
2. **Next Steps:**
   - Reach out to the author or maintainers to gather more context, reproduce steps, and clarify the expected behavior.
   - Once requirements are defined, identify the relevant components in `cli/` or `ui/` based on the issue title.
---

## [#1020] Make sure that we select the branch that is the closest possible to the one requested
**Link:** https://github.com/TarasMazepa/stax/issues/1020

### Analysis
- **Description Detail Level:** Medium (Approx. 215 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Enhance the branch selection logic across the CLI to always pick the branch that most closely matches the user's request, likely using Levenshtein distance or a similar string metric.
2. **Scope:** Modifying a core branch resolution utility, likely in `cli/lib/context/` or `cli/lib/utils/`.
3. **Execution:**
   - Implement or integrate a string similarity algorithm (e.g., Levenshtein distance).
   - Update the branch selection functions to compute the distance between the user's input and all available branch names.
   - Return the branch with the lowest distance, and potentially prompt the user if the distance is above a certain threshold (indicating a likely typo).
4. **Verification:** Create comprehensive unit tests with various typos and similar branch names to ensure the algorithm consistently selects the intended branch.
---

## [#1019] stax get - support multiple branches
**Link:** https://github.com/TarasMazepa/stax/issues/1019

### Analysis
- **Description Detail Level:** Low (Approx. 0 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description is extremely sparse or missing entirely. Needs more context, use cases, or reproduction steps before work can begin.

### Implementation Plan
1. **Investigation Required:** The issue description lacks sufficient detail to formulate a specific implementation plan.
2. **Next Steps:**
   - Reach out to the author or maintainers to gather more context, reproduce steps, and clarify the expected behavior.
   - Once requirements are defined, identify the relevant components in `cli/` or `ui/` based on the issue title.
---

## [#1012] Make sure stax honors default remote setting
**Link:** https://github.com/TarasMazepa/stax/issues/1012

### Analysis
- **Description Detail Level:** Low (Approx. 0 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description is extremely sparse or missing entirely. Needs more context, use cases, or reproduction steps before work can begin.

### Implementation Plan
1. **Investigation Required:** The issue description lacks sufficient detail to formulate a specific implementation plan.
2. **Next Steps:**
   - Reach out to the author or maintainers to gather more context, reproduce steps, and clarify the expected behavior.
   - Once requirements are defined, identify the relevant components in `cli/` or `ui/` based on the issue title.
---

## [#970] when asking user a question introduce a third state when user's answer was inconclusive
**Link:** https://github.com/TarasMazepa/stax/issues/970

### Analysis
- **Description Detail Level:** Low (Approx. 69 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Improve CLI prompts to handle ambiguous or inconclusive user answers by introducing a 'third state' instead of just defaulting or failing.
2. **Scope:** Modifying the interactive prompt utilities, likely in `cli/lib/utils/prompt.dart` or `cli/lib/console/`.
3. **Execution:**
   - Update the `ask()` or `prompt()` functions to parse a wider range of inputs.
   - Introduce an `Inconclusive` enum state alongside `Yes`/`No` or `Success`/`Failure`.
   - Update command logic (like in `commit`, `rebase`) to re-prompt or fail gracefully when an inconclusive state is returned.
4. **Verification:** Add unit tests to simulate different user stdin inputs, verifying that confusing answers loop back or exit safely.
---

## [#944] allow: stax commit -upb "My commit" --gh <commands targetted to gh create pr command>
**Link:** https://github.com/TarasMazepa/stax/issues/944

### Analysis
- **Description Detail Level:** Low (Approx. 0 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description is extremely sparse or missing entirely. Needs more context, use cases, or reproduction steps before work can begin.

### Implementation Plan
1. **Investigation Required:** The issue description lacks sufficient detail to formulate a specific implementation plan.
2. **Next Steps:**
   - Reach out to the author or maintainers to gather more context, reproduce steps, and clarify the expected behavior.
   - Once requirements are defined, identify the relevant components in `cli/` or `ui/` based on the issue title.
---

## [#941] stax amend - check for successful commit and push and abort rebase
**Link:** https://github.com/TarasMazepa/stax/issues/941

### Analysis
- **Description Detail Level:** Low (Approx. 0 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description is extremely sparse or missing entirely. Needs more context, use cases, or reproduction steps before work can begin.

### Implementation Plan
1. **Investigation Required:** The issue description lacks sufficient detail to formulate a specific implementation plan.
2. **Next Steps:**
   - Reach out to the author or maintainers to gather more context, reproduce steps, and clarify the expected behavior.
   - Once requirements are defined, identify the relevant components in `cli/` or `ui/` based on the issue title.
---

## [#901] stax log - limit amount of commits shown to the user
**Link:** https://github.com/TarasMazepa/stax/issues/901

### Analysis
- **Description Detail Level:** Low (Approx. 0 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description is extremely sparse or missing entirely. Needs more context, use cases, or reproduction steps before work can begin.

### Implementation Plan
1. **Investigation Required:** The issue description lacks sufficient detail to formulate a specific implementation plan.
2. **Next Steps:**
   - Reach out to the author or maintainers to gather more context, reproduce steps, and clarify the expected behavior.
   - Once requirements are defined, identify the relevant components in `cli/` or `ui/` based on the issue title.
---

## [#891] Let Arch users experience Stax
**Link:** https://github.com/TarasMazepa/stax/issues/891

### Analysis
- **Description Detail Level:** Medium (Approx. 131 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Package Stax for Arch Linux users (e.g., an AUR package) to expand the installation options.
2. **Scope:** Creating a new PKGBUILD file and adding a publishing step to the CI/CD pipeline.
3. **Execution:**
   - Create an `arch/` or `aur/` directory containing the `PKGBUILD` script.
   - The script should fetch the latest Dart release of Stax, compile it (`dart compile exe bin/stax.dart -o stax`), and place the binary in `/usr/bin/`.
   - Update GitHub Actions to automatically publish or update the AUR repository on a new GitHub Release.
4. **Verification:** Test the `PKGBUILD` locally in an Arch Linux Docker container or VM to ensure `makepkg -si` installs the CLI correctly.
---

## [#881] stax settings - show clarification which settings are being shown to user
**Link:** https://github.com/TarasMazepa/stax/issues/881

### Analysis
- **Description Detail Level:** Low (Approx. 0 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description is extremely sparse or missing entirely. Needs more context, use cases, or reproduction steps before work can begin.

### Implementation Plan
1. **Investigation Required:** The issue description lacks sufficient detail to formulate a specific implementation plan.
2. **Next Steps:**
   - Reach out to the author or maintainers to gather more context, reproduce steps, and clarify the expected behavior.
   - Once requirements are defined, identify the relevant components in `cli/` or `ui/` based on the issue title.
---

## [#861] measurement for performance - like how much time specific command takes in specific situation
**Link:** https://github.com/TarasMazepa/stax/issues/861

### Analysis
- **Description Detail Level:** Low (Approx. 0 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description is extremely sparse or missing entirely. Needs more context, use cases, or reproduction steps before work can begin.

### Implementation Plan
1. **Investigation Required:** The issue description lacks sufficient detail to formulate a specific implementation plan.
2. **Next Steps:**
   - Reach out to the author or maintainers to gather more context, reproduce steps, and clarify the expected behavior.
   - Once requirements are defined, identify the relevant components in `cli/` or `ui/` based on the issue title.
---

## [#860] stress test for big repositories with merge commits
**Link:** https://github.com/TarasMazepa/stax/issues/860

### Analysis
- **Description Detail Level:** Low (Approx. 0 characters)
- **Implementation Complexity Estimate:** Medium (Codebase maintenance)
- **Missing Points / Needs Clarification:**
  - Description is extremely sparse or missing entirely. Needs more context, use cases, or reproduction steps before work can begin.

### Implementation Plan
1. **Investigation Required:** The issue description lacks sufficient detail to formulate a specific implementation plan.
2. **Next Steps:**
   - Reach out to the author or maintainers to gather more context, reproduce steps, and clarify the expected behavior.
   - Once requirements are defined, identify the relevant components in `cli/` or `ui/` based on the issue title.
---

## [#839] stax move head would fail if trying to navigate to origin/main
**Link:** https://github.com/TarasMazepa/stax/issues/839

### Analysis
- **Description Detail Level:** Medium (Approx. 434 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Fix a bug in `stax move head` where navigating to `origin/main` fails due to improper ref parsing.
2. **Scope:** Modifying `cli/lib/commands/move_command.dart` and ref-parsing utilities in `cli/lib/context/`.
3. **Execution:**
   - Inspect how `move head` handles remote branch references versus local ones.
   - Update the regex or parsing logic to correctly identify `origin/<branch>` as a valid remote tracking branch.
   - Ensure the command executes a `git checkout` or internal equivalent that supports detached heads or tracking setups appropriately for remote refs.
4. **Verification:** Add a test case in `cli/test/commands/move_command_test.dart` that specifically tests moving the HEAD to a remote ref like `origin/main`.
---

## [#827] stax move - add a flag to move based on `stax log --all` tree
**Link:** https://github.com/TarasMazepa/stax/issues/827

### Analysis
- **Description Detail Level:** Low (Approx. 0 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description is extremely sparse or missing entirely. Needs more context, use cases, or reproduction steps before work can begin.

### Implementation Plan
1. **Investigation Required:** The issue description lacks sufficient detail to formulate a specific implementation plan.
2. **Next Steps:**
   - Reach out to the author or maintainers to gather more context, reproduce steps, and clarify the expected behavior.
   - Once requirements are defined, identify the relevant components in `cli/` or `ui/` based on the issue title.
---

## [#821] introduce staxlive, staxdev alliases for repository so current changes could be tested without much hustle
**Link:** https://github.com/TarasMazepa/stax/issues/821

### Analysis
- **Description Detail Level:** Medium (Approx. 122 characters)
- **Implementation Complexity Estimate:** Medium (Codebase maintenance)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Introduce `staxlive` and `staxdev` aliases to make testing local changes easier without interfering with the global Stax installation.
2. **Scope:** Updating the development guide and potentially adding a setup script in `scripts/` or modifying `bin/stax.dart` for dev mode.
3. **Execution:**
   - Create a `scripts/setup_dev_aliases.sh` that maps `staxdev` to `dart run bin/stax.dart`.
   - Optionally, add a `--dev` hidden flag in the root command parser to enable extra logging or use an isolated config directory.
   - Update `CONTRIBUTING.md` or `guides/` to instruct new contributors on how to use these aliases.
4. **Verification:** Ensure the script is executable and works across bash/zsh environments.
---

## [#820] git remote - offer multichoice for picking remote instead of picking one ourselves
**Link:** https://github.com/TarasMazepa/stax/issues/820

### Analysis
- **Description Detail Level:** Low (Approx. 81 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** When interacting with multiple remotes, prompt the user to select one instead of Stax automatically picking the first/default one.
2. **Scope:** Modifying `cli/lib/context/context_git_remote.dart` and commands like `push` or `get`.
3. **Execution:**
   - Identify where Stax queries for remotes (e.g., `git remote -v`).
   - If `remotes.length > 1`, invoke the interactive prompt utility (from `cli/lib/console/`) to display a selection menu.
   - Pass the selected remote name down to the subsequent git operations.
4. **Verification:** Create a mock git repository with multiple remotes (e.g., `origin` and `upstream`) in the test suite and verify the prompt is triggered.
---

## [#800] rebase locally and bulk push as a background task (?)
**Link:** https://github.com/TarasMazepa/stax/issues/800

### Analysis
- **Description Detail Level:** Medium (Approx. 270 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Optimize the rebase workflow by performing rebases locally and deferring the bulk push operation to a background task, improving perceived performance.
2. **Scope:** Significant architectural change in `cli/lib/commands/rebase_command.dart` and the introduction of a background daemon/task queue.
3. **Execution:**
   - Refactor the `rebase` logic to perform all tree updates locally first.
   - Create a detached process or daemon (e.g., `cli/lib/daemon/`) that queues the required `git push --force-with-lease` operations.
   - Provide a way for the user to check the status of background pushes (e.g., `stax status`).
4. **Verification:** Heavy integration testing required to ensure background pushes do not conflict with subsequent local operations or cause detached HEAD states on failure.
---

## [#797] simplify logic for figuring out remote head
**Link:** https://github.com/TarasMazepa/stax/issues/797

### Analysis
- **Description Detail Level:** Medium (Approx. 105 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Simplify the logic used to determine the remote head of the current branch, reducing complexity and potential bugs.
2. **Scope:** Refactoring `cli/lib/context/context_git_remote_head.dart` or similar context files.
3. **Execution:**
   - Review the current `git rev-parse` or branch tracking commands used.
   - Replace complex manual parsing with a simpler, direct Git command like `git rev-parse --abbrev-ref @{u}` or `git for-each-ref`.
   - Ensure error handling gracefully catches cases where no upstream is set.
4. **Verification:** Run existing context tests and add edge cases for detached heads, no remotes, and multiple remotes.
---

## [#796] stax rebase - support rebase for cases when parent is a commit or we can't rebase specific node
**Link:** https://github.com/TarasMazepa/stax/issues/796

### Analysis
- **Description Detail Level:** Medium (Approx. 294 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Support rebasing in complex scenarios, such as when the parent is a specific commit hash rather than a branch, or when a specific node cannot be cleanly rebased.
2. **Scope:** Enhancing the tree manipulation logic in `cli/lib/tree/` and `cli/lib/commands/rebase_command.dart`.
3. **Execution:**
   - Update the `RebaseContext` to accept commit hashes in addition to branch names as the target base.
   - Implement a fallback mechanism (`git rebase --onto`) for nodes that fail standard rebasing, or allow interactive skipping/dropping.
   - Ensure the internal graph representation correctly links to commit nodes, not just branch nodes.
4. **Verification:** Create a complex tree fixture in the test suite with dangling commits and verify the rebase successfully transplants the branch onto the specific commit hash.
---

## [#795] stax - daily tips
**Link:** https://github.com/TarasMazepa/stax/issues/795

### Analysis
- **Description Detail Level:** Medium (Approx. 147 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Implement a 'Daily Tips' feature to educate users on advanced Stax commands upon CLI execution.
2. **Scope:** Adding a tips registry in `cli/lib/console/` and modifying the main entry point in `cli/bin/stax.dart`.
3. **Execution:**
   - Create a JSON or Dart list containing useful tips (e.g., "Tip: Use `stax move head` to...").
   - Implement logic to randomly select a tip and print it to stderr/stdout on successful command execution (perhaps once per day using a timestamp in `~/.config/stax/config`).
   - Add a configuration flag (`stax settings show-tips false`) to let users disable it.
4. **Verification:** Verify the config toggle works and that tips are printed conditionally without breaking command output parsing.
---

## [#794] stax commit/ammend - optimize checking for changes in repo
**Link:** https://github.com/TarasMazepa/stax/issues/794

### Analysis
- **Description Detail Level:** Medium (Approx. 349 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Optimize `stax commit` and `stax amend` to check for actual changes in the working directory before executing, preventing empty commits.
2. **Scope:** Modifying `commit_command.dart` and `amend_command.dart`.
3. **Execution:**
   - Before executing the internal `git commit` logic, run `git status --porcelain` or `git diff --cached --quiet`.
   - If no changes are detected (and it's not an `--allow-empty` scenario), exit early with a helpful message instead of failing or creating a blank node.
4. **Verification:** Write unit tests simulating an unmodified working tree and assert that the command exits gracefully with the correct status code.
---

## [#793] stax amend - check for error code in result of git commit --amend --no-edit
**Link:** https://github.com/TarasMazepa/stax/issues/793

### Analysis
- **Description Detail Level:** Low (Approx. 36 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description is extremely sparse or missing entirely. Needs more context, use cases, or reproduction steps before work can begin.

### Implementation Plan
1. **Investigation Required:** The issue description lacks sufficient detail to formulate a specific implementation plan.
2. **Next Steps:**
   - Reach out to the author or maintainers to gather more context, reproduce steps, and clarify the expected behavior.
   - Once requirements are defined, identify the relevant components in `cli/` or `ui/` based on the issue title.
---

## [#792] stax rebase - skip push until very last command
**Link:** https://github.com/TarasMazepa/stax/issues/792

### Analysis
- **Description Detail Level:** Medium (Approx. 226 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Defer all push operations during a `stax rebase` until the very end, speeding up the process and allowing atomic failures.
2. **Scope:** Refactoring the execution loop in `cli/lib/commands/rebase_command.dart`.
3. **Execution:**
   - Change the current behavior where each branch rebase immediately pushes.
   - Collect a list of successfully rebased branches during the tree traversal.
   - After all local rebases are complete, execute a single batch push or a loop of pushes at the end.
4. **Verification:** Verify through integration tests that if a rebase fails halfway, no partial pushes have been sent to the remote.
---

## [#791] stax rebase - add --all, which will go and rebase all of your branches
**Link:** https://github.com/TarasMazepa/stax/issues/791

### Analysis
- **Description Detail Level:** Low (Approx. 97 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Add an `--all` flag to `stax rebase` that attempts to rebase every single local branch in the repository against their respective upstreams.
2. **Scope:** Modifying `rebase_command.dart`.
3. **Execution:**
   - Add `--all` to the `ArgParser` for the rebase command.
   - If `--all` is passed, retrieve all local branches using the context utilities, group them by their tree roots, and sequentially execute the rebase logic on each tree.
   - Implement robust error boundaries so a conflict in one branch doesn't halt the entire `--all` process.
4. **Verification:** Create a test repository with multiple independent branch stacks and ensure `--all` updates all of them correctly.
---

## [#790] stax move - add new directions line and Line
**Link:** https://github.com/TarasMazepa/stax/issues/790

### Analysis
- **Description Detail Level:** Medium (Approx. 187 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Add support for a new direction type, `Line`, in the `stax move` command to enable linear traversal up and down the commit history.
2. **Scope:** Modifying the movement parsing logic in `cli/lib/commands/move_command.dart` and tree navigation.
3. **Execution:**
   - Define the semantics of `Line` (e.g., navigating ancestors/descendants without branching off).
   - Implement the traversal algorithm to follow the primary lineage.
   - Add `line` as an acceptable argument value in the parser.
4. **Verification:** Add specific tests for `stax move line` traversing up and down a linear commit history.
---

## [#789] stax move - add left and right directions
**Link:** https://github.com/TarasMazepa/stax/issues/789

### Analysis
- **Description Detail Level:** Low (Approx. 0 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description is extremely sparse or missing entirely. Needs more context, use cases, or reproduction steps before work can begin.

### Implementation Plan
1. **Investigation Required:** The issue description lacks sufficient detail to formulate a specific implementation plan.
2. **Next Steps:**
   - Reach out to the author or maintainers to gather more context, reproduce steps, and clarify the expected behavior.
   - Once requirements are defined, identify the relevant components in `cli/` or `ui/` based on the issue title.
---

## [#787] add an ability to specify shadow name for a command
**Link:** https://github.com/TarasMazepa/stax/issues/787

### Analysis
- **Description Detail Level:** Medium (Approx. 341 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Allow users to define aliases or 'shadow names' for existing Stax commands via configuration.
2. **Scope:** Modifying `cli/lib/config/` and the main command runner in `cli/bin/stax.dart`.
3. **Execution:**
   - Update the configuration schema (e.g., `~/.config/stax/config.yaml`) to parse an `aliases:` map.
   - Intercept the incoming arguments in `main()`, check if the first argument matches an alias, and expand it to the full command string before passing it to the `CommandRunner`.
4. **Verification:** Create a test config with `aliases: { 'c': 'commit' }` and ensure `stax c` executes the commit command.
---

## [#786] stax commit - avoid double prefixing branch names
**Link:** https://github.com/TarasMazepa/stax/issues/786

### Analysis
- **Description Detail Level:** Medium (Approx. 168 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Prevent `stax commit` from doubly prefixing branch names if the branch is already prefixed (e.g., `feature/feature/name`).
2. **Scope:** Modifying branch name generation logic, likely in `cli/lib/commands/commit_command.dart` or `cli/lib/utils/branch_name.dart`.
3. **Execution:**
   - Inspect the logic that prepends prefixes (like ticket numbers or usernames).
   - Add a regex or string check: `if (branchName.startsWith(prefix)) { return branchName; }` before applying the prefix.
4. **Verification:** Write unit tests passing an already-prefixed branch name to ensure it remains unchanged, while a non-prefixed one gets prefixed.
---

## [#773] Support Windows installation via officail `winget` package manager
**Link:** https://github.com/TarasMazepa/stax/issues/773

### Analysis
- **Description Detail Level:** Medium (Approx. 304 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Add support for distributing Stax via the official Windows `winget` package manager.
2. **Scope:** Creating a winget manifest and updating GitHub Actions release workflows.
3. **Execution:**
   - Create a winget manifest YAML file detailing the installer URL (from GitHub Releases), hash, and metadata.
   - Update the CI pipeline to automatically submit a PR to the `microsoft/winget-pkgs` repository using a tool like `wingetcreate` upon a new Stax release.
4. **Verification:** Manually validate the manifest using `winget validate` and perform a test installation locally on a Windows machine.
---

## [#770] stax amend/commit add flag to stage only provided files
**Link:** https://github.com/TarasMazepa/stax/issues/770

### Analysis
- **Description Detail Level:** Medium (Approx. 218 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Add a flag (e.g., `-o` or `--only`) to `stax amend` and `stax commit` to only stage and commit explicitly provided files, bypassing the default 'stage all' behavior.
2. **Scope:** Modifying the `ArgParser` and git execution logic in `amend_command.dart` and `commit_command.dart`.
3. **Execution:**
   - Add the new flag to accept a list of file paths.
   - If the flag is present, change the underlying `git add .` command to `git add <file1> <file2>`.
   - Ensure error handling if the provided files do not exist or are not tracked.
4. **Verification:** Write integration tests verifying that only the specified files are included in the resulting commit, leaving other modified files in the working directory.
---

## [#749] stax get - all local, all remote
**Link:** https://github.com/TarasMazepa/stax/issues/749

### Analysis
- **Description Detail Level:** Medium (Approx. 102 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Enhance `stax get` with options like `--all-local` or `--all-remote` to fetch or list all branches instead of just the current context.
2. **Scope:** Modifying `cli/lib/commands/get_command.dart`.
3. **Execution:**
   - Add the new boolean flags to the command's `ArgParser`.
   - Based on the flags, alter the underlying git fetch/list commands (e.g., `git fetch --all` or `git branch -r`).
   - Update the UI/console output to clearly format the resulting lists of branches.
4. **Verification:** Ensure the flags are mutually exclusive if necessary, and test against a repository with multiple local and remote branches.
---

## [#731] stax pull - do not attempt to return back to the branch that was just deleted
**Link:** https://github.com/TarasMazepa/stax/issues/731

### Analysis
- **Description Detail Level:** Low (Approx. 0 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description is extremely sparse or missing entirely. Needs more context, use cases, or reproduction steps before work can begin.

### Implementation Plan
1. **Investigation Required:** The issue description lacks sufficient detail to formulate a specific implementation plan.
2. **Next Steps:**
   - Reach out to the author or maintainers to gather more context, reproduce steps, and clarify the expected behavior.
   - Once requirements are defined, identify the relevant components in `cli/` or `ui/` based on the issue title.
---

## [#728] Start signing binaries
**Link:** https://github.com/TarasMazepa/stax/issues/728

### Analysis
- **Description Detail Level:** Low (Approx. 47 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description is extremely sparse or missing entirely. Needs more context, use cases, or reproduction steps before work can begin.

### Implementation Plan
1. **Investigation Required:** The issue description lacks sufficient detail to formulate a specific implementation plan.
2. **Next Steps:**
   - Reach out to the author or maintainers to gather more context, reproduce steps, and clarify the expected behavior.
   - Once requirements are defined, identify the relevant components in `cli/` or `ui/` based on the issue title.
---

## [#722] Soft reset use cases
**Link:** https://github.com/TarasMazepa/stax/issues/722

### Analysis
- **Description Detail Level:** Medium (Approx. 436 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Document or implement specific use cases for soft resets within Stax, making it easier to un-commit without losing work.
2. **Scope:** Modifying `cli/lib/commands/reset_command.dart` (if it exists) or creating documentation in `guides/`.
3. **Execution:**
   - If a command: Implement `stax reset --soft` which executes `git reset --soft HEAD~1` but maintains Stax's tree integrity.
   - If documentation: Add a guide explaining how to achieve a soft reset using standard git commands within a Stax workflow.
4. **Verification:** If a command, verify via tests that the Stax tree is updated correctly after the soft reset.
---

## [#719] use alternative git config methods to avoid cases when users haven't configured stax
**Link:** https://github.com/TarasMazepa/stax/issues/719

### Analysis
- **Description Detail Level:** Low (Approx. 64 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Fall back to alternative git configuration methods if the primary Stax configuration is missing or malformed.
2. **Scope:** Modifying `cli/lib/config/stax_config.dart` or context parsing logic.
3. **Execution:**
   - Wrap config reads in a try-catch.
   - If reading `~/.stax/config` fails, attempt to read global git config keys (e.g., `git config --global stax.setting`).
   - Provide a warning to the user that a fallback was used.
4. **Verification:** Write tests simulating a missing config file and assert that the values are successfully retrieved from git config.
---

## [#713] stax rebase - add flag for rebasing not current branch but the most base branch in the branch
**Link:** https://github.com/TarasMazepa/stax/issues/713

### Analysis
- **Description Detail Level:** Low (Approx. 70 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Add a flag to `stax rebase` that rebases the entire base branch (the root of the current stack) rather than just the current branch.
2. **Scope:** Modifying `rebase_command.dart` and tree traversal logic.
3. **Execution:**
   - Add a `--base` flag to the parser.
   - When passed, traverse up the internal tree representation to find the root node of the current branch stack.
   - Execute the rebase starting from that root node, which will subsequently cascade down to the current branch.
4. **Verification:** Create a multi-tiered branch stack in the test suite and verify that `--base` successfully rebases the root and updates all descendants.
---

## [#698] stax settings refactor
**Link:** https://github.com/TarasMazepa/stax/issues/698

### Analysis
- **Description Detail Level:** Medium (Approx. 388 characters)
- **Implementation Complexity Estimate:** Medium (Codebase maintenance)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Refactor the internal settings module for better maintainability and type safety.
2. **Scope:** Completely overhauling `cli/lib/config/` and `cli/lib/settings/`.
3. **Execution:**
   - Introduce a strongly-typed settings model using a package like `json_serializable`.
   - Migrate all dictionary-based config accesses (`config['key']`) to object properties (`config.key`).
   - Consolidate default values and validation logic into a single factory class.
4. **Verification:** Run the entire test suite to ensure no commands break due to missing or incorrectly typed settings.
---

## [#695] stax commit - avoid creating PRs that target gone branches
**Link:** https://github.com/TarasMazepa/stax/issues/695

### Analysis
- **Description Detail Level:** Medium (Approx. 133 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Prevent `stax commit` from automatically creating Pull Requests against branches that have already been deleted ('gone' branches) on the remote.
2. **Scope:** Modifying PR creation logic, likely interacting with the GitHub API in `cli/lib/services/github_service.dart` or similar.
3. **Execution:**
   - Before issuing the PR creation API call, execute a check (`git ls-remote` or an API query) to verify the target base branch exists.
   - If the target is missing, fallback to `main` or prompt the user to select a new base branch.
4. **Verification:** Mock the GitHub API response for a deleted branch and ensure the command handles it gracefully without throwing an unhandled exception.
---

## [#694] Add sqlite integration to store additional information about repository
**Link:** https://github.com/TarasMazepa/stax/issues/694

### Analysis
- **Description Detail Level:** Medium (Approx. 101 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Integrate a SQLite database to store complex, persistent repository metadata that is difficult to represent purely in git refs or config files.
2. **Scope:** Adding SQLite dependencies to `cli/pubspec.yaml` and implementing a database layer in `cli/lib/db/`.
3. **Execution:**
   - Add `sqlite3` or `sqflite_common_ffi` to dependencies.
   - Create a singleton DB manager that initializes a `.stax/meta.db` file.
   - Create tables for caching tree structures, PR statuses, or analytics.
   - Refactor context utilities to query the DB for faster reads.
4. **Verification:** Write unit tests for the DB manager (using an in-memory database) to verify CRUD operations work correctly.
---

## [#693] use verbose git commands
**Link:** https://github.com/TarasMazepa/stax/issues/693

### Analysis
- **Description Detail Level:** Medium (Approx. 125 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Ensure all internal Git commands executed by Stax use verbose output flags to aid in debugging and logging.
2. **Scope:** Modifying the central git execution utility in `cli/lib/context/` (e.g., `git_run.dart`).
3. **Execution:**
   - Identify where `Process.run('git', args)` is called.
   - Inject `-v` or `--verbose` into the arguments list for applicable commands (like `fetch`, `push`, `rebase`).
   - Ensure the verbose output is captured and written to a debug log file, while keeping the user-facing CLI output clean unless a debug flag is passed.
4. **Verification:** Run a command with the debug flag and assert that the verbose git output is present in the logs.
---

## [#691] stax amend - rebase ensure one commit per branch
**Link:** https://github.com/TarasMazepa/stax/issues/691

### Analysis
- **Description Detail Level:** Medium (Approx. 432 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Modify `stax amend` to enforce a strict 'one commit per branch' rule, automatically squashing if necessary.
2. **Scope:** Modifying `amend_command.dart` and potentially `rebase_command.dart`.
3. **Execution:**
   - Check the commit count of the current branch relative to its base (`git rev-list --count base..HEAD`).
   - If count > 1, execute an interactive rebase (`git rebase -i`) programmatically, or use `git reset --soft base` followed by a new `git commit`, squashing all changes into one.
4. **Verification:** Create a test scenario where a user manually added multiple commits to a Stax branch, run `stax amend`, and verify the branch is squashed to a single commit.
---

## [#682] stax pull - add rebase flags  -m -r -b
**Link:** https://github.com/TarasMazepa/stax/issues/682

### Analysis
- **Description Detail Level:** Medium (Approx. 246 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Add rebase-specific flags (`-m`, `-r`, `-b`) to the `stax pull` command for finer control over the pull strategy.
2. **Scope:** Modifying `pull_command.dart`.
3. **Execution:**
   - Add the flags to the `ArgParser`.
   - Map these flags to their Git equivalents (e.g., `--rebase=merges` for `-m`, `--rebase=interactive` for `-i` if applicable).
   - Append these arguments to the underlying `git pull` execution.
4. **Verification:** Verify through unit tests that passing these flags to Stax correctly formats the underlying `git pull` shell command.
---

## [#679] prototype dart docker based commandline e2e tests
**Link:** https://github.com/TarasMazepa/stax/issues/679

### Analysis
- **Description Detail Level:** Medium (Approx. 381 characters)
- **Implementation Complexity Estimate:** Medium (Codebase maintenance)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Prototype end-to-end (E2E) tests using Docker to ensure the CLI works correctly across different OS environments.
2. **Scope:** Adding a `Dockerfile.e2e` and a new script in `scripts/` or `cli/test/e2e/`.
3. **Execution:**
   - Create a Dockerfile that installs Dart, Git, and necessary dependencies.
   - Write a bash script that builds the Stax binary, initializes a mock Git repository, and runs a series of Stax commands (commit, rebase, push).
   - Integrate this script into GitHub Actions to run on every PR.
4. **Verification:** Ensure the GitHub Action successfully runs the Docker container and reports test failures accurately.
---

## [#678] stax analytics
**Link:** https://github.com/TarasMazepa/stax/issues/678

### Analysis
- **Description Detail Level:** High (Approx. 696 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Implement an analytics system to track CLI command usage and errors, helping maintainers understand user behavior.
2. **Scope:** Adding a telemetry service in `cli/lib/analytics/`.
3. **Execution:**
   - Integrate a lightweight analytics SDK (like Sentry for errors, or a custom HTTP endpoint for usage).
   - Wrap the main `CommandRunner` execution in a try-catch to log crashes.
   - Log command invocations (e.g., `analytics.logEvent('command_run', {'name': 'rebase'})`).
   - **Crucial:** Add an opt-in/opt-out prompt on first run and respect it in the configuration.
4. **Verification:** Write unit tests using a mock analytics client to ensure events are fired for commands, but skipped if telemetry is disabled.
---

## [#677] stax settings - honor git config
**Link:** https://github.com/TarasMazepa/stax/issues/677

### Analysis
- **Description Detail Level:** Medium (Approx. 216 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Make Stax settings deeply integrate with and honor global/local `.gitconfig` values to avoid duplicating configurations.
2. **Scope:** Modifying `cli/lib/config/stax_config.dart`.
3. **Execution:**
   - When parsing settings, check if a value exists in the Stax config. If not, fallback to reading from `git config --get stax.<setting>`.
   - This is particularly useful for things like default prefixes, auto-push behavior, or UI preferences.
4. **Verification:** Create a test environment with specific `git config` keys set, and verify the Stax config resolver returns those values.
---

## [#556] stax daemon watch command
**Link:** https://github.com/TarasMazepa/stax/issues/556

### Analysis
- **Description Detail Level:** Medium (Approx. 153 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Create a `stax daemon watch` command that runs in the background and automatically responds to repository changes (like auto-fetching or auto-rebasing).
2. **Scope:** Significant architectural addition in `cli/lib/commands/daemon_command.dart`.
3. **Execution:**
   - Implement a long-running Dart isolate or process.
   - Use a file system watcher package (like `watcher`) on the `.git/` directory or poll `git remote update`.
   - When changes are detected, trigger non-intrusive background updates or display system notifications.
4. **Verification:** Integration testing is complex; manually verify that modifying a remote branch triggers the daemon's reaction logic.
---

## [#486] Implement stax update
**Link:** https://github.com/TarasMazepa/stax/issues/486

### Analysis
- **Description Detail Level:** Medium (Approx. 320 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Implement a `stax update` command to easily upgrade the CLI to the latest version directly from the terminal.
2. **Scope:** Modifying `cli/lib/commands/update_command.dart`.
3. **Execution:**
   - Query the GitHub Releases API (`repos/TarasMazepa/stax/releases/latest`) to check for a newer version.
   - If available, download the appropriate binary for the host OS.
   - Replace the current executable (requires handling OS-specific file locking, especially on Windows).
4. **Verification:** Mock the GitHub API response and verify the download/replace logic works in a controlled, temporary directory.
---

## [#466] Rendering of the tree should not depend on what is checked out now.
**Link:** https://github.com/TarasMazepa/stax/issues/466

### Analysis
- **Description Detail Level:** Medium (Approx. 172 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Ensure the visual rendering of the Stax tree (via CLI output or UI) is independent of the currently checked-out branch, showing the full context.
2. **Scope:** Modifying the tree rendering logic in `cli/lib/console/tree_renderer.dart`.
3. **Execution:**
   - Disconnect the tree traversal algorithm from relying on `HEAD` as the absolute starting point.
   - Ensure the tree builder queries all relevant branches and their relationships first, then highlights `HEAD` visually, rather than only building the tree around `HEAD`.
4. **Verification:** Write a test that checks out a deeply nested branch and verify the rendered tree output still contains the root branches and siblings.
---

## [#401] Distribute package with nixpkg
**Link:** https://github.com/TarasMazepa/stax/issues/401

### Analysis
- **Description Detail Level:** Medium (Approx. 357 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Distribute Stax using the Nix package manager (`nixpkgs`) to support declarative environments.
2. **Scope:** Creating a `default.nix` or `flake.nix` file in the repository root.
3. **Execution:**
   - Write a Nix derivation that uses `dart` to fetch dependencies, compile the binary, and package it.
   - Test the build using `nix-build` or `nix run`.
   - Document the Nix installation method in the `README.md`.
4. **Verification:** Run a local Nix build inside a clean NixOS or Nix docker container to ensure hermetic reproducibility.
---

## [#394] New command 'delete-merged-prs-branches'
**Link:** https://github.com/TarasMazepa/stax/issues/394

### Analysis
- **Description Detail Level:** Medium (Approx. 322 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Create a cleanup command, `stax delete-merged-prs-branches`, to easily prune local branches that have been merged on the remote.
2. **Scope:** Modifying `cli/lib/commands/cleanup_command.dart`.
3. **Execution:**
   - Query the GitHub API to find merged PRs authored by the user.
   - Cross-reference the source branches of those PRs with local branches.
   - Execute `git branch -D <branch>` for matches, and clean up Stax's internal tree state.
4. **Verification:** Mock the GitHub API to return a merged PR, and verify the corresponding local branch is deleted by the command.
---

## [#375] Command that ensured that all the nodes have exactly one commit
**Link:** https://github.com/TarasMazepa/stax/issues/375

### Analysis
- **Description Detail Level:** Medium (Approx. 278 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Create a command or utility that strictly enforces that every node (branch) in the Stax tree has exactly one commit (squashing if necessary).
2. **Scope:** Modifying `cli/lib/commands/enforce_single_commit_command.dart`.
3. **Execution:**
   - Traverse the entire branch tree.
   - For each branch, calculate commit count relative to its base.
   - If count > 1, execute an automated squash rebase for that branch.
4. **Verification:** Create a fixture with multiple multi-commit branches and verify the command squashes all of them while maintaining branch relationships.
---

## [#373] Improve rebase of trees
**Link:** https://github.com/TarasMazepa/stax/issues/373

### Analysis
- **Description Detail Level:** High (Approx. 503 characters)
- **Implementation Complexity Estimate:** Medium (Needs scope definition)
- **Missing Points / Needs Clarification:**
  - Description seems fairly complete, though specific technical requirements might need to be hashed out during implementation.

### Implementation Plan
1. **Goal:** Improve the robustness and speed of rebasing entire trees (stacks of branches) when upstream changes occur.
2. **Scope:** Core refactoring of `cli/lib/tree/tree_rebaser.dart`.
3. **Execution:**
   - Analyze the current tree rebase bottleneck (e.g., redundant git checkouts, slow merge conflict detection).
   - Implement a strategy like `git rebase --update-refs` if applicable, or optimize the topological sort order to minimize context switching.
   - Add better error recovery if a node in the middle of the tree conflicts.
4. **Verification:** Benchmark the tree rebase execution time before and after the change on a large stack, and ensure conflict handling is intact.
---
