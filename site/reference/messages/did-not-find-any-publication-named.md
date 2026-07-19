---
message: "Did not find any publication named \"%s\"."
slug: did-not-find-any-publication-named
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:6704"
reproduced: false
---

# `Did not find any publication named "%s".`

## What it means

A psql `\dRp` command with a name pattern matched no publication. The placeholder is the pattern. This is psql reporting an empty result, not a server error.

## When it happens

It fires when `\dRp pattern` finds no publication whose name matches, because none exists or the pattern does not match.

## How to fix

List all publications with a bare `\dRp`, check the pattern, and create the publication with `CREATE PUBLICATION` if it is missing.

## Example

*Illustrative* — a pattern matching no publication.

```text
\dRp mypub
-- Did not find any publication named "mypub".
```

## Related

- [Did not find any publications](./did-not-find-any-publications.md)
- [Did not find any settings](./did-not-find-any-settings.md)
