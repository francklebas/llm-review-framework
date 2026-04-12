# Project Context Template

Copy this file to `<project-name>/codereview-context.md` and fill in each section.
The LLM code reviewer will use this to understand the codebase it is reviewing.

Keep it concise — this is injected into the prompt, not documentation.

---

## Stack

<!-- Main framework, language, styling, database, etc. -->

**Framework:** ...
**Language:** ...
**Styling:** ...
**Database/CMS:** ...
**Deployment:** ...
**Tests:** ...

## Architecture

<!-- Key directories and their purpose. Only list what helps the reviewer understand the code. -->

- `src/` — ...
- `lib/` — ...

## Sensitive areas

<!-- Modules or patterns that require extra caution during review. -->

- ...

## Code conventions

<!-- Patterns the team follows. The reviewer will flag deviations. -->

- ...

## Banned anti-patterns

<!-- Things that should never appear in this codebase. -->

- ...
