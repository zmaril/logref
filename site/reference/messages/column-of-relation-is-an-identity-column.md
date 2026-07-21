---
message: "column \"%s\" of relation \"%s\" is an identity column"
slug: column-of-relation-is-an-identity-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:7924"
  - "postgres/src/backend/commands/tablecmds.c:8292"
  - "postgres/src/backend/commands/tablecmds.c:14713"
reproduced: true
---

# `column "%s" of relation "%s" is an identity column`

## What it means

An operation was refused because the target column is an identity column and the operation conflicts with identity semantics. The placeholders name the column and relation. Depending on context this rejects, for example, adding a default to an identity column or overriding a `GENERATED ALWAYS` identity without the proper clause.

## When it happens

Trying to set a default on an identity column, insert/update an explicit value into a `GENERATED ALWAYS AS IDENTITY` column without `OVERRIDING SYSTEM VALUE`, or another change that clashes with the column's identity nature.

## How to fix

Work with identity rules rather than against them: use `OVERRIDING SYSTEM VALUE` to write an explicit value into a `GENERATED ALWAYS` identity (if you truly must), let the identity supply the value (omit the column or use `DEFAULT`), or convert the column with `ALTER TABLE ... ALTER COLUMN ... DROP IDENTITY` if it should no longer be an identity. Do not add a conflicting default to an identity column.

## Example

*Reproduced* — captured from `reproducers/scenarios/36_constraints_partitioning.sql`.

```sql
ALTER TABLE s36.idt ALTER COLUMN a SET DEFAULT 5;
```

Produces:

```text
ERROR:  column "a" of relation "idt" is an identity column
```

## Related

- [cannot assign to system column](./cannot-assign-to-system-column.md)
- [column inherits from generated column of different kind](./column-inherits-from-generated-column-of-different-kind.md)
