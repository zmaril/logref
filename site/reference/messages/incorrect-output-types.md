---
message: "incorrect output types"
slug: incorrect-output-types
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/pageinspect/brinfuncs.c:273"
  - "postgres/contrib/pageinspect/rawpage.c:312"
reproduced: false
---

# `incorrect output types`

## What it means

Internal error. A function that returns a set of records was handed a result descriptor whose column types do not match the tuples it produced. It is a consistency guard between a set-returning function and its expected row shape.

## When it happens

It fires from set-returning function support code when the declared output columns and the actual returned tuple types disagree. Ordinary queries do not surface it; it points to a mismatch in a function's declared versus produced record type.

## How to fix

This is an internal guard. Check any set-returning function or `RECORD`-returning call involved for a column-list definition that does not match what the function returns; align the `AS (col type, ...)` list with the function's real output. If no such function is involved, capture the query and report a reproducible case.

## Example

*Illustrative* — a record-returning call whose column list does not match the function.

```text
ERROR:  incorrect output types
```

## Related

- [number of aliases does not match number of columns](./number-of-aliases-does-not-match-number-of-columns.md)
- [number of columns does not match number of values](./number-of-columns-does-not-match-number-of-values.md)
