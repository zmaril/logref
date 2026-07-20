---
message: "cannot insert into foreign table \"%s\""
slug: cannot-insert-into-foreign-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/executor/execMain.c:1144"
reproduced: false
---

# `cannot insert into foreign table "%s"`

## What it means

An `INSERT` targeted a foreign table whose wrapper does not support inserts. The foreign-data wrapper backing the table did not implement the routines needed to write rows, so the insert cannot proceed. The placeholder is the table name.

## When it happens

It occurs when you insert into a foreign table whose FDW is read-only, or was configured without write support.

## How to fix

Use an FDW and server configuration that support writes, or load the data on the remote side directly. Check the wrapper's documentation for whether and how it supports `INSERT`.

## Example

*Illustrative* — insert into a read-only foreign table.

```text
ERROR:  cannot insert into foreign table "remote_events"
```

## Related

- [cannot insert into column of view](./cannot-insert-into-column-of-view.md)
- [cannot insert tuples in a parallel worker](./cannot-insert-tuples-in-a-parallel-worker.md)
