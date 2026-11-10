# Files from Seed Repository

This directory contains shared documentation files, guidelines, and standards that are automatically synchronized from the central [repository-seed](https://github.com/TarasMazepa/repository-seed) repository.

## Purpose

To maintain consistent standards, guidelines, and policies across all repositories in the ecosystem, shared documentation is managed centrally in `repository-seed` and propagated to downstream repositories automatically.

Files in `docs/from-seed/` represent these centrally maintained documents.

## Why This File Exists

This `README.md` explains why the `docs/from-seed/` directory exists and documents the operational and contribution rules for developers and automated coding agents working in this repository.

## Contribution Guidelines

> [!WARNING]
> **Do not edit files in this folder directly within this repository.**
> Any local changes made in `docs/from-seed/` will be overwritten the next time the seed synchronization workflow runs.

To propose changes, updates, or additions to any file in this directory:
1. Make your changes in the upstream [TarasMazepa/repository-seed](https://github.com/TarasMazepa/repository-seed) repository under `docs/from-seed/`.
2. Submit a pull request against `main` in `repository-seed`.
3. Once merged, the GitHub Actions workflow in `repository-seed` will automatically open pull requests to propagate the updates to this repository and all other participating repositories.

## Related Seed Files

- [AGENTS.md](../../AGENTS.md): The root agent instructions file, also synchronized from the seed repository.
