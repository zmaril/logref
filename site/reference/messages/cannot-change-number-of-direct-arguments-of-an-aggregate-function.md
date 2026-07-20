---
message: "cannot change number of direct arguments of an aggregate function"
slug: cannot-change-number-of-direct-arguments-of-an-aggregate-function
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/catalog/pg_aggregate.c:716"
reproduced: false
---

# `cannot change number of direct arguments of an aggregate function`

## What it means

A `CREATE OR REPLACE AGGREGATE` changed how many direct arguments an ordered-set aggregate takes. Direct arguments are those before the `ORDER BY` in the aggregate's call, and their count is part of the aggregate's identity, so it cannot change in a replacement.

## When it happens

It occurs when replacing an existing ordered-set or hypothetical-set aggregate with a different number of direct arguments.

## How to fix

Keep the direct-argument count unchanged when replacing the aggregate. To change it, drop the aggregate and create a new one with the desired signature.

## Example

*Illustrative* — changing direct-argument count.

```text
ERROR:  cannot change number of direct arguments of an aggregate function
```

## Related

- [cannot change return type of existing function](./cannot-change-return-type-of-existing-function.md)
- [cannot change whether a procedure has output parameters](./cannot-change-whether-a-procedure-has-output-parameters.md)
