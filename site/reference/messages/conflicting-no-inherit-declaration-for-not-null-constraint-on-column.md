---
message: "conflicting NO INHERIT declaration for not-null constraint on column \"%s\""
slug: conflicting-no-inherit-declaration-for-not-null-constraint-on-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/catalog/heap.c:2986"
  - "postgres/src/backend/parser/parse_utilcmd.c:2659"
reproduced: false
---

# `conflicting NO INHERIT declaration for not-null constraint on column "%s"`

## What it means

A table definition declared a not-null constraint on a column both with and without NO INHERIT, in a way that contradicts itself. The placeholder is the column name. A single not-null constraint cannot be both inheritable and NO INHERIT.

## When it happens

Writing a `CREATE`/`ALTER TABLE` where the same column's not-null constraint is specified once as inheritable and once as NO INHERIT, or where an inherited definition disagrees with an explicit one.

## How to fix

Decide whether the not-null constraint should be NO INHERIT or inheritable, and declare it consistently in one place. Remove the contradictory second declaration so the column has a single, coherent not-null definition.

## Example

*Illustrative* — contradictory NO INHERIT declarations.

```text
ERROR:  conflicting NO INHERIT declaration for not-null constraint on column "id"
```

## Related

- [conflicting NO INHERIT declarations for not-null constraints on column](./conflicting-no-inherit-declarations-for-not-null-constraints-on-column.md)
- [cannot change NO INHERIT status of not-null constraint on relation](./cannot-change-no-inherit-status-of-not-null-constraint-on-relation.md)
