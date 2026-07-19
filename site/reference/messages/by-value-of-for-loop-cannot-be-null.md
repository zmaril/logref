---
message: "BY value of FOR loop cannot be null"
slug: by-value-of-for-loop-cannot-be-null
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NULL_VALUE_NOT_ALLOWED
    code: "22004"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:2786"
reproduced: false
---

# `BY value of FOR loop cannot be null`

## What it means

A PL/pgSQL integer `FOR` loop had a `BY` step expression that evaluated to null. The step controls how the loop counter advances, and a null step has no defined meaning.

## When it happens

It occurs when a PL/pgSQL `FOR i IN a..b BY step` loop runs and `step` is null, often because it came from a null variable or parameter.

## How to fix

Ensure the `BY` expression yields a non-null positive integer. Guard the variable feeding it against null, or supply a default such as `coalesce(step, 1)` before the loop.

## Example

*Illustrative* — a null loop step.

```sql
DO $$ DECLARE s int := NULL; BEGIN FOR i IN 1..10 BY s LOOP END LOOP; END $$;
```

## Related

- [by value of for loop must be greater than zero](./by-value-of-for-loop-must-be-greater-than-zero.md)
- [cannot accumulate null arrays](./cannot-accumulate-null-arrays.md)
