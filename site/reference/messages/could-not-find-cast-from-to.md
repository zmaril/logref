---
message: "could not find cast from %u to %u"
slug: could-not-find-cast-from-to
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:14188"
reproduced: false
---

# `could not find cast from %u to %u`

## What it means

`ALTER TABLE ... ALTER COLUMN TYPE` needed a cast between two types (given by OID) and could not find one. This is an internal guard reached after the command believed a cast should exist.

## When it happens

It fires during a column-type change when the rewrite step looks up the cast it planned to use and it is not present — for example a cast dropped between planning and execution.

## How to fix

This is an internal error. Make sure any cast the type change relies on exists (`CREATE CAST`) and is not being dropped concurrently. If it recurs on stable definitions, note the two types and report a reproducible case.

## Example

*Illustrative* — a missing cast during a column-type change.

```text
ERROR:  could not find cast from 16400 to 23
```

## Related

- [could not convert type to](./could-not-convert-type-to.md)
- [could not find array type for datatype](./could-not-find-array-type-for-datatype.md)
