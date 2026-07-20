---
message: "index \"%s\" was concurrently dropped"
slug: index-was-concurrently-dropped
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:3179"
  - "postgres/src/backend/statistics/stat_utils.c:189"
reproduced: false
---

# `index "%s" was concurrently dropped`

## What it means

The index a command was using was dropped by another session before the command finished with it. Postgres detects the concurrent drop and aborts rather than operating on a vanished object.

## When it happens

It arises when one session runs `DROP INDEX` (especially without holding a strong lock, as with the concurrent path) while another session's plan or maintenance operation still references that index.

## How to fix

Retry the command; on retry the planner will build a plan that does not use the dropped index. If it recurs, coordinate DDL so indexes are not dropped while queries depending on them are in flight.

## Example

*Illustrative* — the index disappeared mid-operation.

```text
ERROR:  index "my_idx" was concurrently dropped
```

## Related

- [index does not exist](./index-does-not-exist.md)
- [index does not belong to table](./index-does-not-belong-to-table.md)
