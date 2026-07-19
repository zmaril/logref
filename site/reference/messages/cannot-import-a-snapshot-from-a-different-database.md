---
message: "cannot import a snapshot from a different database"
slug: cannot-import-a-snapshot-from-a-different-database
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/time/snapmgr.c:1561"
reproduced: false
---

# `cannot import a snapshot from a different database`

## What it means

`SET TRANSACTION SNAPSHOT` tried to import a snapshot that was exported by a session connected to a different database. A snapshot describes row visibility within one database, so it cannot be imported across databases.

## When it happens

It occurs when the exporting and importing sessions are connected to different databases in the cluster. It is common when a client passes a snapshot id between connections without matching the database.

## How to fix

Export and import the snapshot from sessions connected to the same database. Point both connections at the identical database name before sharing the snapshot id.

## Example

*Illustrative* — import from a different database.

```text
ERROR:  cannot import a snapshot from a different database
```

## Related

- [cannot export a snapshot from a subtransaction](./cannot-export-a-snapshot-from-a-subtransaction.md)
- [cannot export a snapshot from within a transaction](./cannot-export-a-snapshot-from-within-a-transaction.md)
