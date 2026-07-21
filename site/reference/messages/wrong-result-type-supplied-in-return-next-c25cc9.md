---
message: "wrong result type supplied in RETURN NEXT"
slug: wrong-result-type-supplied-in-return-next-c25cc9
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:3407"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:3540"
reproduced: false
---

# `wrong result type supplied in RETURN NEXT`

## What it means

A PL/pgSQL `RETURN NEXT` supplied a value whose type does not match the function's declared return type for a set-returning function.

## When it happens

It arises in a `RETURNS SETOF ...` PL/pgSQL function when a `RETURN NEXT` expression yields a row or scalar of the wrong type or shape for the declared result.

## How to fix

Make each `RETURN NEXT` produce a value matching the function's return type — the same column set and types for a composite return, or the right scalar type for a scalar set. Cast expressions or adjust the row construction to match.

## Example

*Illustrative* — a mistyped RETURN NEXT.

```text
ERROR:  wrong result type supplied in RETURN NEXT
```

## Related

- [wrong number of arguments in hypothetical-set function](./wrong-number-of-arguments-in-hypothetical-set-function.md)
- [unrecognized table-function returnMode: %d](./unrecognized-table-function-returnmode.md)
