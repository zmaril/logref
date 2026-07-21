---
message: "column \"%s\" named in partition key does not exist"
slug: column-named-in-partition-key-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_COLUMN
    code: "42703"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:20541"
reproduced: true
---

# `column "%s" named in partition key does not exist`

## What it means

A `PARTITION BY` clause referenced a column that the table does not have. The partition key can only be built from columns that exist on the table.

## When it happens

It happens on `CREATE TABLE ... PARTITION BY ... (col)` when the named column is misspelled or is not defined in the table.

## How to fix

Use a column that exists on the table in the partition key, or add the column to the table definition first. Check spelling and case of the column name.

## Example

*Reproduced* — captured from `reproducers/scenarios/31_createtable_view_trigger.sql`.

```sql
CREATE TABLE repro.ct15 (a serial, b bigserial, PRIMARY KEY (a)) PARTITION BY HASH (nonexistent);
```

Produces:

```text
ERROR:  column "nonexistent" named in partition key does not exist
```

## Related

- [column of relation does not exist](./column-number-of-relation-does-not-exist.md)
- [cannot use constant expression as partition key](./cannot-use-constant-expression-as-partition-key.md)
