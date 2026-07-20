---
message: "constraints cannot have index expressions"
slug: constraints-cannot-have-index-expressions
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/index.c:1944"
reproduced: false
---

# `constraints cannot have index expressions`

## What it means

Internal index-building code found an index expression on a constraint-backed index, which is not allowed. Constraint indexes (primary key, unique) must be over plain columns, not expressions. This is an internal check.

## When it happens

It fires during creation of the index backing a constraint when the index definition unexpectedly contains an expression.

## How to fix

This is an internal error; user-level DDL normally prevents expression indexes on constraints. If you reach it, review the constraint/index definition — a unique constraint cannot be over an expression; use a unique expression index without a constraint instead. Report it if it appears unexpectedly.

## Example

*Illustrative* — an expression on a constraint index.

```text
ERROR:  constraints cannot have index expressions
```

## Related

- [constraint must be PRIMARY, UNIQUE or EXCLUDE](./constraint-must-be-primary-unique-or-exclude.md)
- [constraint contains a whole-row reference to table](./constraint-contains-a-whole-row-reference-to-table.md)
