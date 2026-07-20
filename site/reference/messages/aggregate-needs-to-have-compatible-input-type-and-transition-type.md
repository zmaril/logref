---
message: "aggregate %u needs to have compatible input type and transition type"
slug: aggregate-needs-to-have-compatible-input-type-and-transition-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/executor/nodeAgg.c:4034"
  - "postgres/src/backend/executor/nodeWindowAgg.c:3162"
reproduced: false
---

# `aggregate %u needs to have compatible input type and transition type`

## What it means

Internal error. Executor setup for an aggregate found its declared input type and transition (state) type are not compatible for the code path being used. It is a consistency check on aggregate definitions at execution time.

## When it happens

It should not occur for aggregates defined through supported means. Reaching it points to an aggregate whose type declarations do not fit the executor's expectations — often a custom aggregate defined inconsistently — rather than to your query.

## How to fix

If a custom aggregate is involved, review its input, state, and transition-function types for consistency and redefine it to match. For built-in aggregates, capture the query and report it as an internal issue.

## Example

*Illustrative* — an aggregate with incompatible declared types.

```text
ERROR:  aggregate 16400 needs to have compatible input type and transition type
```

## Related

- [aggregate transition data type cannot be](./aggregate-transition-data-type-cannot-be.md)
- [is an aggregate function](./is-an-aggregate-function.md)
