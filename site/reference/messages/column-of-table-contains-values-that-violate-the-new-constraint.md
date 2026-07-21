---
message: "column \"%s\" of table \"%s\" contains values that violate the new constraint"
slug: column-of-table-contains-values-that-violate-the-new-constraint
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CHECK_VIOLATION
    code: "23514"
call_sites:
  - "postgres/src/backend/commands/typecmds.c:3303"
reproduced: true
---

# `column "%s" of table "%s" contains values that violate the new constraint`

## What it means

A new domain check constraint being added would be violated by data already stored in a column that uses that domain. Existing rows fail the constraint, so it cannot be added while they remain.

## When it happens

It happens on `ALTER DOMAIN ... ADD CONSTRAINT` when a table column of that domain holds values that do not satisfy the new check.

## How to fix

Correct or remove the violating rows, or add the constraint as `NOT VALID` and validate later once the data conforms. Query the column to find values that fail the check.

## Example

*Reproduced* — captured from `reproducers/scenarios/37_alter_type_column_tablespace.sql`.

```sql
ALTER DOMAIN s37.posint ADD CONSTRAINT gt0 CHECK (VALUE > 0);
```

Produces:

```text
ERROR:  column "v" of table "usedom" contains values that violate the new constraint
```

## Related

- [column of table contains null values](./column-of-table-contains-null-values.md)
- [constraint must be validated on child tables too](./constraint-must-be-altered-on-child-tables-too.md)
