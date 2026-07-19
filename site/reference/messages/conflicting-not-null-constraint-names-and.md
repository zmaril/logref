---
message: "conflicting not-null constraint names \"%s\" and \"%s\""
slug: conflicting-not-null-constraint-names-and
passthrough: false
api: [elog, ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/catalog/heap.c:3000"
  - "postgres/src/backend/parser/parse_utilcmd.c:800"
reproduced: false
---

# `conflicting not-null constraint names "%s" and "%s"`

## What it means

Two different names were given for the not-null constraint on the same column. The placeholders are the two names. A column's not-null constraint can have only one name; the definition supplied two conflicting ones.

## When it happens

A `CREATE`/`ALTER TABLE` (often combining inherited and explicit constraints, or a `LIKE ... INCLUDING CONSTRAINTS`) that assigns two distinct constraint names to one column's not-null constraint.

## How to fix

Give the column's not-null constraint a single name, or let Postgres name it, and remove the conflicting second name. Reconcile inherited and explicit constraint names so they agree.

## Example

*Illustrative* — two names for one not-null constraint.

```text
ERROR:  conflicting not-null constraint names "nn_a" and "nn_b"
```

## Related

- [conflicting NO INHERIT declarations for not-null constraints on column](./conflicting-no-inherit-declarations-for-not-null-constraints-on-column.md)
- [conflicting NULL/NOT NULL constraints](./conflicting-null-not-null-constraints.md)
