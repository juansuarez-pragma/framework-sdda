# Repository Guidelines

## Project Structure & Module Organization
- `sdda/`: core SDDA framework (specs in `01_specs`, prompts in `04_prompts`, CLI + generators in `05_generators`, examples in `06_examples`).
- `sdda_demo/`: Flutter demo app using the framework; tests live in `test/`, feature code under `lib/features/`.
- `docs/`: process and architecture guides; start with `docs/00_SDDA_Plan_Maestro.md`.
- Root guides for agents: `CLAUDE.md`, `CODEX_GUIDANCE.md`.

## Build, Test, and Development Commands
- Install CLI deps: `dart pub get` in `sdda/05_generators`.
- SDDA CLI: `dart run sdda/05_generators/bin/sdda.dart --version` (check), `generate feature <name> --spec=<path>`, `validate --all` (architecture + naming + structure).
- Demo app: from `sdda_demo/`, run `flutter pub get`, then `flutter test --coverage`; to serve web preview, `flutter run -d chrome`.

## Coding Style & Naming Conventions
- Dart/Flutter with Very Good Analysis (`sdda/analysis_options.yaml`); fix lints before committing.
- Format with `dart format .` (or `flutter format .`) and keep single quotes; prefer 120c soft limit and strict inference/casts.
- Clean Architecture layout: `lib/features/<feature>/{domain,data,presentation}/...`; use PascalCase for types, camelCase for members, snake_case for files; keep imports explicit (avoid unused exports).
- Generated/auto files (`*.g.dart`, `*.freezed.dart`, mocks) are excluded from analysis but keep sources clean.

## Testing Guidelines
- Write contract tests before generation: place feature tests in `sdda/02_contracts/` or `sdda_demo/test/` mirroring `lib/features/...`.
- Target 100% coverage for testable code (excludes generated/l10n); fail builds on missing coverage.
- Name tests `<subject>_<behavior>` and prefer `group()` per use case; validate with `flutter test --coverage` plus `sdda ... validate`.

## Commit & Pull Request Guidelines
- Use Conventional Commits (`feat: ...`, `fix: ...`, `chore: ...`, `docs: ...`, `test: ...`, `refactor: ...`); keep messages in English or consistent Spanish.
- Before opening a PR: run lints (`dart analyze` or `flutter analyze`), format, `sdda ... validate`, and full tests with coverage.
- PRs should describe scope, include steps to reproduce/verify, link issues, and add screenshots for UI changes; mention coverage deltas when relevant.

## Agent-Specific Tips
- Always read `CODEX_GUIDANCE.md` and `CLAUDE.md` first; follow existing patterns from `sdda/03_context/patterns/examples`.
- When adding new prompts/specs, keep YAML minimal and validated; never invent APIs—mirror the patterns in `05_generators` and demo feature implementations.
