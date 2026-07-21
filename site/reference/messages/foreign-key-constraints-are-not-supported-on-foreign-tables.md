---
message: "foreign key constraints are not supported on foreign tables"
slug: foreign-key-constraints-are-not-supported-on-foreign-tables
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:11203"
  - "postgres/src/backend/commands/tablecmds.c:11636"
  - "postgres/src/backend/parser/parse_utilcmd.c:937"
  - "postgres/src/backend/parser/parse_utilcmd.c:1082"
reproduced: false
---

# `foreign key constraints are not supported on foreign tables`

## What it means

A foreign-key constraint was requested on a foreign table. The placeholder-free text states the limitation: foreign tables are backed by external data the local server does not fully control, so it cannot enforce referential integrity on them.

## When it happens

Running `CREATE FOREIGN TABLE ... REFERENCES ...`, `ALTER FOREIGN TABLE ... ADD FOREIGN KEY`, or referencing a foreign table as the target of a foreign key.

## How to fix

Do not define foreign keys on foreign tables. Enforce referential integrity on the remote side (in the source database) if possible, or validate the relationships in your application/ETL layer. Local constraints cannot police data that lives in an external system.

## Example

*Illustrative* — a foreign key on a foreign table.

```sql
ALTER FOREIGN TABLE ft ADD FOREIGN KEY (a) REFERENCES t(id);
```

## Related

- [cannot specify in binary mode](./cannot-specify-in-binary-mode.md)
- [is not allowed with UNION/INTERSECT/EXCEPT](./is-not-allowed-with-union-intersect-except.md)
