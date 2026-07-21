---
message: "unique constraints are not supported on foreign tables"
slug: unique-constraints-are-not-supported-on-foreign-tables
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:920"
  - "postgres/src/backend/parser/parse_utilcmd.c:1049"
reproduced: false
---

# `unique constraints are not supported on foreign tables`

## What it means

A statement tried to place a `UNIQUE` (or primary-key) constraint on a foreign table, which the foreign-data-wrapper model does not support because the remote store owns the data.

## When it happens

It arises from `CREATE FOREIGN TABLE` or `ALTER FOREIGN TABLE` with a `UNIQUE`/`PRIMARY KEY` clause. PostgreSQL cannot enforce uniqueness on data it does not store.

## How to fix

Remove the uniqueness constraint from the foreign-table definition. If uniqueness must be enforced, do it on the remote side, or import the data into a local table where a constraint can be maintained.

## Example

*Illustrative* — a unique constraint on a foreign table.

```text
ERROR:  unique constraints are not supported on foreign tables
```

## Related

- [user mapping for "%s" does not exist for server "%s"](./user-mapping-for-does-not-exist-for-server.md)
- [unsupported %s action for foreign key constraint using PERIOD](./unsupported-action-for-foreign-key-constraint-using-period.md)
