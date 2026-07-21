---
message: "cannot set logged status of a temporary sequence"
slug: cannot-set-logged-status-of-a-temporary-sequence
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:500"
reproduced: false
---

# `cannot set logged status of a temporary sequence`

## What it means

An `ALTER SEQUENCE ... SET LOGGED`/`SET UNLOGGED` targeted a temporary sequence. A temporary sequence is inherently session-local and has no persistent-logging status to change.

## When it happens

It occurs when you try to change the logged status of a sequence created as `TEMPORARY`.

## How to fix

Do not set the logged status of temporary sequences. Use a permanent sequence if you need to control its logged/unlogged persistence.

## Example

*Illustrative* — setting logged status on a temp sequence.

```text
ERROR:  cannot set logged status of a temporary sequence
```

## Related

- [cannot set options for relation](./cannot-set-options-for-relation.md)
- [cannot rename column of typed table](./cannot-rename-column-of-typed-table.md)
