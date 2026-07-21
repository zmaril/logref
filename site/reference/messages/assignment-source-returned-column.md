---
message: "assignment source returned %d column"
slug: assignment-source-returned-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/analyze.c:3279"
reproduced: false
---

# `assignment source returned %d column`

## What it means

An assignment (such as `SELECT INTO` or a PL/pgSQL assignment from a query) received a different number of columns than the target expected, so the values cannot be mapped to the target.

## When it happens

It occurs when a query feeding an assignment returns a column count that does not match the number of assignment targets — for example selecting two columns into one variable, or the reverse.

## How to fix

Make the source query's column count match the assignment targets. Adjust the select list or the target list so they line up, or use a record/row target that matches the query's shape.

## Example

*Illustrative* — a column-count mismatch in an assignment.

```text
ERROR:  assignment source returned 2 column
```

## Related

- [argument name used more than once](./argument-name-used-more-than-once.md)
- [a column definition list is required for functions returning record](./a-column-definition-list-is-required-for-functions-returning-record.md)
