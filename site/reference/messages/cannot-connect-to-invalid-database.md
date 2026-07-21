---
message: "cannot connect to invalid database \"%s\""
slug: cannot-connect-to-invalid-database
passthrough: false
api: [ereport]
level: [FATAL]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/utils/init/postinit.c:1143"
reproduced: false
---

# `cannot connect to invalid database "%s"`

## What it means

A connection targeted a database whose catalog entry is marked invalid. A database can be left invalid if a `DROP DATABASE` was interrupted, and such a database cannot be connected to. The placeholder is the database name.

## When it happens

It occurs when connecting to a database whose `datconnlimit` marks it invalid, typically after a failed drop.

## How to fix

Drop the invalid database with `DROP DATABASE` (connect to another database such as `postgres` first) so the interrupted drop completes, then recreate it if needed. An invalid database only exists as a leftover to be cleaned up.

## Example

*Illustrative* — connecting to an invalid database.

```text
FATAL:  cannot connect to invalid database "olddb"
```

## Related

- [cannot continue wal streaming recovery has already ended](./cannot-continue-wal-streaming-recovery-has-already-ended.md)
- [cannot drop objects owned by because they are required by the database system](./cannot-drop-objects-owned-by-because-they-are-required-by-the-database-system.md)
