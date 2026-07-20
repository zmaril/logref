---
message: "no value found for parameter %d"
slug: no-value-found-for-parameter
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/executor/execCurrent.c:290"
  - "postgres/src/backend/executor/execExprInterp.c:3113"
reproduced: false
---

# `no value found for parameter %d`

## What it means

A query referenced a bind parameter (`$n`) for which no value was supplied. The placeholder is the parameter number. Every referenced parameter needs a value at execution.

## When it happens

It arises when executing a prepared statement or a parameterized query where the parameter list is shorter than the highest `$n` used, or a client binds fewer values than the statement references.

## How to fix

Supply a value for every parameter the statement uses, matching the count and positions of the `$n` placeholders. Check the client code that binds parameters for an off-by-one or a missing bind, and confirm the parameter numbers are contiguous from `$1`.

## Example

*Illustrative* — referencing an unbound parameter.

```sql
PREPARE s AS SELECT $1, $2;  EXECUTE s (1);  -- no value for $2
```

## Related

- [invalid paramid](./invalid-paramid.md)
- [lastval is not yet defined in this session](./lastval-is-not-yet-defined-in-this-session.md)
