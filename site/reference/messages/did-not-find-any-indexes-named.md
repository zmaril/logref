---
message: "Did not find any indexes named \"%s\"."
slug: did-not-find-any-indexes-named
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:4257"
reproduced: false
---

# `Did not find any indexes named "%s".`

## What it means

A psql `\di` command with a name pattern matched no index. The placeholder is the pattern. This is psql reporting an empty result, not a server error.

## When it happens

It fires when `\di pattern` finds no index whose name matches, because none exists or the pattern does not match.

## How to fix

List all indexes with a bare `\di`, check the pattern and search path, and use `\diS` if you meant to include system indexes.

## Example

*Illustrative* — a pattern matching no index.

```text
\di nosuch_idx
-- Did not find any indexes named "nosuch_idx".
```

## Related

- [Did not find any indexes](./did-not-find-any-indexes.md)
- [Did not find any relation named](./did-not-find-any-relation-named.md)
