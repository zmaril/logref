---
message: "conflicting NO INHERIT declarations for not-null constraints on column \"%s\""
slug: conflicting-no-inherit-declarations-for-not-null-constraints-on-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:769"
  - "postgres/src/backend/parser/parse_utilcmd.c:804"
reproduced: false
---

# `conflicting NO INHERIT declarations for not-null constraints on column "%s"`

## What it means

During parse analysis of a table definition, multiple not-null constraint declarations for the same column disagreed about NO INHERIT. The placeholder is the column name. The declarations cannot be reconciled into one constraint.

## When it happens

A `CREATE TABLE` (often with inheritance or `LIKE`) that pulls in more than one not-null declaration for a column with differing NO INHERIT settings.

## How to fix

Unify the not-null declarations for the column so they agree on inheritance. Remove or adjust the conflicting source — whether an inherited constraint, a `LIKE` clause, or an explicit one — so a single NO INHERIT setting applies.

## Example

*Illustrative* — conflicting inherited not-null declarations.

```text
ERROR:  conflicting NO INHERIT declarations for not-null constraints on column "id"
```

## Related

- [conflicting NO INHERIT declaration for not-null constraint on column](./conflicting-no-inherit-declaration-for-not-null-constraint-on-column.md)
- [conflicting not-null constraint names and](./conflicting-not-null-constraint-names-and.md)
