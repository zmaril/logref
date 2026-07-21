---
message: "cannot alter type of a column used by a generated column"
slug: cannot-alter-type-of-a-column-used-by-a-generated-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:15749"
reproduced: true
---

# `cannot alter type of a column used by a generated column`

## What it means

An `ALTER TABLE ... ALTER COLUMN ... TYPE` was blocked because a generated column depends on the column being altered. The generation expression reads the column, so changing its type could invalidate that expression.

## When it happens

It occurs when you alter the type of a column that a stored generated column references in its `GENERATED ALWAYS AS (...)` expression.

## How to fix

Drop the generated column, alter the source column's type, then recreate the generated column against the new type. Postgres does not rewrite the dependent generation expression automatically.

## Example

*Reproduced* — captured from `reproducers/scenarios/37_alter_type_column_tablespace.sql`.

```sql
ALTER TABLE s37.gdep ALTER COLUMN a TYPE bigint;
```

Produces:

```text
ERROR:  cannot alter type of a column used by a generated column
```

## Related

- [cannot alter type of a column used by a view or rule](./cannot-alter-type-of-a-column-used-by-a-view-or-rule.md)
- [cannot alter type of a column used in a trigger definition](./cannot-alter-type-of-a-column-used-in-a-trigger-definition.md)
