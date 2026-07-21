---
message: "primary key constraints are not supported on foreign tables"
slug: primary-key-constraints-are-not-supported-on-foreign-tables
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:911"
  - "postgres/src/backend/parser/parse_utilcmd.c:1039"
reproduced: false
---

# `primary key constraints are not supported on foreign tables`

## What it means

A `PRIMARY KEY` was requested on a foreign table. Foreign tables reference data in an external system that Postgres does not control, so it cannot enforce a primary key on them.

## When it happens

It arises from `CREATE FOREIGN TABLE` with a `PRIMARY KEY`, or `ALTER FOREIGN TABLE ... ADD PRIMARY KEY`.

## How to fix

Omit the primary key. If you need the planner to treat a column as unique for optimization, you can add a `NOT ENFORCED`/informational constraint where supported, or ensure uniqueness in the remote system. Enforcement itself must happen where the data actually lives.

## Example

*Illustrative* — declaring a primary key on a foreign table.

```text
ERROR:  primary key constraints are not supported on foreign tables
```

## Related

- [referenced relation "%s" is not a table](./referenced-relation-is-not-a-table.md)
- [relation "%s" is of wrong relation kind](./relation-is-of-wrong-relation-kind.md)
