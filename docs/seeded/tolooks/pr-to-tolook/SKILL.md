---
name: pr-to-tolook
description: >-
  Extracts architectural inquiries, backlog ideas, and implementation spikes from a GitHub pull request and converts it into a structured ToLook in TOLOOKS.md. Use when the user asks to shelve, convert, or close an older or exploratory PR to revisit later with fresh eyes.
---

# PR to ToLook

This skill guides the agent in analyzing an existing GitHub pull request—especially older, stalled, prototype, or paused PRs—extracting its core intent, context, and prototype insights, converting it into a structured entry in `TOLOOKS.md`, and cleanly closing the PR so the work can be revisited later with fresh eyes.

## Why Convert a PR to a ToLook?

Older PRs frequently accumulate merge conflicts, touch deprecated APIs, or suffer from scope drift. Leaving them open clutters the review queue, generates noise in automated health audits, and consumes CI resources; closing them outright discards valuable research, architecture discussions, and prototype code.

Converting a PR into a ToLook preserves:
1. **The Core Intent**: The underlying problem statement or capability stripped of obsolete implementation details.
2. **The Prototype Artifacts**: Direct links to the PR, commit SHAs, and branch for future reference.
3. **The Lessons & Trade-offs**: Why the PR stalled, what worked, and what architectural flaws to avoid next time.
4. **Actionable Spikes**: Clear candidate options and checklists for when someone returns to the problem with fresh eyes.

---

## Workflow

### 1. Ingest & Inspect the PR
Given a PR number or URL (e.g. `119` or `https://github.com/TarasMazepa/monoapp/pull/119`):

1. Inspect PR metadata, comments, and diff using `gh`:
   ```bash
   gh pr view <PR> --json number,title,body,author,createdAt,url,headRefName,baseRefName,files,additions,deletions,changedFiles,comments
   gh pr diff <PR>
   ```

2. Read key changed files or diff excerpts to understand the prototype mechanism and where the friction occurred.

### 2. Synthesize & Distill (The "Fresh Eyes" Lens)
Analyze the PR critically:
- **Idea**: Formulate a concise 1–2 sentence statement of the desired capability or refactoring.
- **Context**: Document why the PR was opened, its author/date, the branch name, diff size, and why it was shelved (e.g., merge conflicts, architectural rethink, upstream dependency changes).
- **Investigation**:
  - **Prior Art / Spike**: Reference the PR URL (`#<PR>`) and head branch (`<branch>`). Note key files modified and the technical mechanism attempted.
  - **Friction & Open Questions**: Summarize why the original implementation was not merged (e.g. test failures, breaking changes, excessive coupling).
  - **Candidate Options for Fresh Eyes**:
    - *Option A (Fresh Redesign)*: Clean reimplementation using current conventions and architecture.
    - *Option B (Salvage Spike)*: Rebase and cherry-pick specific files or algorithms from the prototype branch.
  - **Phased Action Checklist**: Concrete exploration items for when this ToLook is picked up.

### 3. Record in `TOLOOKS.md` & Open a New PR
1. Locate `TOLOOKS.md` in the repository root. If absent, initialize it from [template.md](../template.md).
2. Determine the next sequential item number under `## Active ToLooks`.
3. Append or insert the synthesized ToLook block.
4. Open a new PR capturing the `TOLOOKS.md` addition (e.g., `stax commit -Abdn "Add ToLook for PR #<PR>" --accept-all`).

#### Recommended ToLook Schema
```markdown
- [ ] **<Next Number>. <Title>**
  - **Idea**: <1–2 sentence statement of what to explore or solve.>
  - **Context**: Originated from PR [#<PR>](<PR_URL>) on branch `<branch>` (<diff stats>). <Why it was paused/closed, what was learned, and why a fresh approach is warranted.>
  - **Investigation**:
    - *Prior Art / PR Spike*: PR [#<PR>](<PR_URL>) attempted <summary of approach>. Key files: [`path/to/file`](path/to/file).
    - *Friction & Lessons*: <Why it stalled: breaking changes, architectural complexity, or superseded APIs>.
    - *Candidate Options*:
      - **Option A (Fresh Redesign)**: <Alternative design or modern pattern>.
      - **Option B (Salvage Prototype)**: <Rebase branch or cherry-pick specific components>.
    - [ ] <Concrete exploration step or verification item 1>
    - [ ] <Concrete exploration step or verification item 2>
```

### 4. Close the Original PR Cleanly (Bidirectional Traceability)
> [!IMPORTANT]
> Wait until the new ToLook PR is reviewed/approved (or merged) and you are happy with how the idea is captured in `TOLOOKS.md`. Always ask the user for confirmation before closing the original PR.

Once the new PR is ready and the user confirms:
1. Post a comment on the original PR referencing both the new PR and `TOLOOKS.md`:
   ```bash
   gh pr comment <PR> --body "Converted into ToLook in \`TOLOOKS.md\` via #<NEW_PR> to preserve context and allow a fresh approach. Closing PR."
   ```
2. Close the original PR:
   ```bash
   gh pr close <PR>
   ```
3. Optionally prune local or remote branches if no longer needed:
   ```bash
   git branch -D <branch> 2>/dev/null || true
   ```
