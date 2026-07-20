---
message: "BY value of FOR loop must be greater than zero"
slug: by-value-of-for-loop-must-be-greater-than-zero
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:2792"
reproduced: false
---

# `BY value of FOR loop must be greater than zero`

## What it means

A PL/pgSQL integer `FOR` loop had a `BY` step of zero or a negative value. The step must be a positive integer; the loop's direction is chosen by the range order, not by the sign of the step.

## When it happens

It occurs when a PL/pgSQL `FOR i IN a..b BY step` loop runs with `step` less than or equal to zero.

## How to fix

Use a positive `BY` value. To count down, keep the step positive and order the bounds with `REVERSE`, as in `FOR i IN REVERSE 10..1 BY 2`.

## Example

*Illustrative* — a non-positive loop step.

```sql
DO $$ BEGIN FOR i IN 1..10 BY 0 LOOP END LOOP; END $$;
```

## Related

- [by value of for loop cannot be null](./by-value-of-for-loop-cannot-be-null.md)
- [cannot accumulate empty arrays](./cannot-accumulate-empty-arrays.md)
