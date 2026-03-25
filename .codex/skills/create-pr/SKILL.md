---
name: Create PR
description: Notes on creating a PR.
---

When creating a pr using the GH cli.
- If you can't authenticate you may have to switch accounts. Use `gh auth switch`
- Use conventional commit titles.
- If the changes are in a monorepo use the specific change name in the title. For example, feature changes in a folder `/backend/` would result in a title: feat(backend): Whatever changed...
- If a PR template in .github exists use this aswell.
- If a branch needs to be created follow these branch naming rules
    - If in a monorepo the name should be in the following pattern: repo-folder(backend)/feat(semantic commit; chore, fix)/branch-name(snake-case branch name)
    - If in a normal repo the name should be in the following pattern: feat(semantic commit; chore, fix)/branch-name(snake-case branch name)
