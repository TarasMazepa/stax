# Files from Seed Repository

This directory contains shared documentation files, guidelines, and standards that are automatically synchronized from the central [repository-seed](https://github.com/TarasMazepa/repository-seed) repository.

## Purpose

To maintain consistent standards, guidelines, and policies across all repositories in the ecosystem, shared documentation is managed centrally in `repository-seed` and propagated to downstream repositories automatically.

Files in `docs/seeded/` represent these centrally maintained documents.

## Why This File Exists

This `README.md` explains why the `docs/seeded/` directory exists and documents the operational and contribution rules for developers and automated coding agents working in this repository.

## Contribution Guidelines

> [!WARNING]
> **Do not edit files in this folder directly within this repository.**
> Any local changes made in `docs/seeded/` will be overwritten the next time the seed synchronization workflow runs.

To propose changes, updates, or additions to any file in this directory:
1. Make your changes in the upstream [TarasMazepa/repository-seed](https://github.com/TarasMazepa/repository-seed) repository under `docs/seeded/`.
2. Submit a pull request against `main` in `repository-seed`.
3. Once merged, the GitHub Actions workflow in `repository-seed` will automatically open pull requests to propagate the updates to this repository and all other participating repositories.

## Documents in This Directory

- [README.md](README.md): Overview and contribution rules for this folder.
- [stax/agents.md](stax/agents.md): Explicit Stax instructions for LLMs and autonomous agents (`stax extras agents.md`).
- [stax/help.md](stax/help.md): Full Stax CLI command and flag reference (`stax help`).
- [tolooks/README.md](tolooks/README.md): The "ToLooks" concept, exploratory scratchpad philosophy, and lifecycle guide.
- [tolooks/template.md](tolooks/template.md): Starter boilerplate template for initializing `TOLOOKS.md` in any repository.

## Related Seed Files

- [AGENTS.md](../../AGENTS.md): The root agent instructions file, also synchronized from the seed repository.
