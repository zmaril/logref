---
message: "conflict log table \"%s\" cannot have rules"
slug: conflict-log-table-cannot-have-rules
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/rewrite/rewriteDefine.c:271"
  - "postgres/src/backend/rewrite/rewriteDefine.c:778"
reproduced: false
---

# `conflict log table "%s" cannot have rules`

## What it means

A `CREATE RULE` targeted a table that serves as a logical-replication conflict log table. The placeholder is the table name. That table is managed by the replication machinery and may not carry user-defined rules.

## When it happens

Defining a rule (`CREATE RULE ... ON conflict_log_table`) on a table designated for conflict logging.

## How to fix

Do not attach rules to the conflict log table. If you need to react to conflict-log rows, use a trigger where supported or process the table's contents separately. Manage the table through the owning replication configuration.

## Example

*Illustrative* — a rule on a conflict log table.

```text
ERROR:  conflict log table "pg_conflict_log" cannot have rules
```

## Related

- [cannot alter conflict log table](./cannot-alter-conflict-log-table.md)
- [cannot set parameter to false for publication](./cannot-set-parameter-to-false-for-publication.md)
