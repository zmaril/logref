---
message: "Did not find any sequences."
slug: did-not-find-any-sequences
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:4291"
reproduced: false
---

# `Did not find any sequences.`

## What it means

A psql `\ds` command found no sequences to list. This is psql reporting an empty result, not a server error.

## When it happens

It fires when `\ds` runs where no sequences are visible on the search path.

## How to fix

Nothing is wrong. If you expected sequences, check the schema and search path; identity and serial columns own sequences that appear here too.

## Example

*Illustrative* — no sequences to show.

```text
\ds
-- Did not find any sequences.
```

## Related

- [Did not find any sequences named](./did-not-find-any-sequences-named.md)
- [Did not find any relations](./did-not-find-any-relations-fc25da.md)
