---
message: "cannot convert whole-row table reference"
slug: cannot-convert-whole-row-table-reference
passthrough: false
api: [elog, ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:2961"
  - "postgres/src/backend/commands/tablecmds.c:3015"
  - "postgres/src/backend/commands/tablecmds.c:15180"
  - "postgres/src/backend/commands/tablecmds.c:23063"
  - "postgres/src/backend/parser/parse_utilcmd.c:1436"
  - "postgres/src/backend/parser/parse_utilcmd.c:1480"
  - "postgres/src/backend/parser/parse_utilcmd.c:1912"
  - "postgres/src/backend/parser/parse_utilcmd.c:2024"
reproduced: false
---

# `cannot convert whole-row table reference`

## What it means

A whole-row reference (using a table's name as a value, which yields a composite of all its columns) could not be converted to the required row type. The placeholder situation arises in constraint or index expressions where a whole-row reference is not permitted or cannot be coerced.

## When it happens

Using a bare table reference `t` as a composite value in a context that does not allow it — for example inside a check constraint or an index expression that references the whole row, or converting a whole-row var to a named composite type that does not match.

## How to fix

Reference specific columns instead of the whole row where the context forbids a whole-row reference. In constraints and index expressions, list the columns you actually need. If you need the composite, ensure the target type matches the table's row type exactly. Restructure the expression to avoid the whole-row form.

## Example

*Illustrative* — a whole-row reference in an index expression.

```sql
CREATE INDEX ON t ((t));
```

Produces:

```text
ERROR:  cannot convert whole-row table reference
DETAIL:  Index expression cannot reference the whole row.
```

## Related

- [type %s is not composite](./type-is-not-composite.md)
- [cannot alter system column](./cannot-alter-system-column.md)
