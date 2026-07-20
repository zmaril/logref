---
message: "cannot perform COPY FREEZE on a foreign table"
slug: cannot-perform-copy-freeze-on-a-foreign-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/copyfrom.c:886"
reproduced: false
---

# `cannot perform COPY FREEZE on a foreign table`

## What it means

A `COPY ... WITH (FREEZE)` targeted a foreign table. `FREEZE` operates on local heap storage that the transaction owns, and a foreign table has no such local storage, so the option does not apply.

## When it happens

It occurs when `COPY FREEZE` is used to load into a foreign table.

## How to fix

Load foreign tables with a plain `COPY` (no `FREEZE`), or load into a local table with `FREEZE` and move the data across. The freeze optimization is only meaningful for local heap tables.

## Example

*Illustrative* — COPY FREEZE into a foreign table.

```text
ERROR:  cannot perform COPY FREEZE on a foreign table
```

## Related

- [cannot perform COPY FREEZE on a partitioned table](./cannot-perform-copy-freeze-on-a-partitioned-table.md)
- [cannot insert into foreign table](./cannot-insert-into-foreign-table.md)
