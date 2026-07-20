---
message: "unexpected object depending on column: %s"
slug: unexpected-object-depending-on-column
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:15640"
  - "postgres/src/backend/commands/tablecmds.c:15791"
reproduced: false
---

# `unexpected object depending on column: %s`

## What it means

Internal error. While dropping or altering a column, dependency processing found a dependent object of a kind it did not expect to hang off a column.

## When it happens

It fires from `ALTER TABLE ... DROP COLUMN` and related paths when the dependency graph contains an entry the code has no handling for. Normal schemas do not trigger it.

## How to fix

This is an internal guard over the catalog's dependency records. If a routine DDL statement reaches it, the dependency entries may be inconsistent; capture the object definitions and report it as a reproducible bug.

## Example

*Illustrative* — an unexpected column dependent.

```text
ERROR:  unexpected object depending on column: rule
```

## Related

- [unrecognized dependency type: %d](./unrecognized-dependency-type.md)
- [unrecognized dependency type '%c' for %s](./unrecognized-dependency-type-for.md)
