---
message: "Did not find any sequences named \"%s\"."
slug: did-not-find-any-sequences-named
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:4266"
reproduced: false
---

# `Did not find any sequences named "%s".`

## What it means

A psql `\ds` command with a name pattern matched no sequence. The placeholder is the pattern. This is psql reporting an empty result, not a server error.

## When it happens

It fires when `\ds pattern` finds no sequence whose name matches, because none exists or the pattern does not match.

## How to fix

List all sequences with a bare `\ds`, and check the pattern and search path.

## Example

*Illustrative* — a pattern matching no sequence.

```text
\ds seq_*
-- Did not find any sequences named "seq_*".
```

## Related

- [Did not find any sequences](./did-not-find-any-sequences.md)
- [Did not find any relations named](./did-not-find-any-relations-named.md)
