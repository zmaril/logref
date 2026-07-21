---
message: "PL/pgSQL functions cannot return type %s"
slug: pl-pgsql-functions-cannot-return-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_comp.c:457"
  - "postgres/src/pl/plpgsql/src/pl_handler.c:478"
reproduced: false
---

# `PL/pgSQL functions cannot return type %s`

## What it means

A PL/pgSQL function was declared to return a type the language cannot produce. The placeholder is the type. Certain pseudo-types cannot be a PL/pgSQL return type.

## When it happens

It arises at `CREATE FUNCTION ... LANGUAGE plpgsql` with a `RETURNS` clause naming a type PL/pgSQL cannot return — for example `internal` or another pseudo-type not usable there.

## How to fix

Return a supported type instead. If the intent requires an internal type, implement the function in C; otherwise redesign so the function returns an ordinary SQL type, `record`, or a composite.

## Example

*Illustrative* — a PL/pgSQL function returning an unsupported pseudo-type.

```text
ERROR:  PL/pgSQL functions cannot return type internal
```

## Related

- [PL/pgSQL functions cannot accept type %s](./pl-pgsql-functions-cannot-accept-type.md)
- [return type of transition function %s is not %s](./return-type-of-transition-function-is-not.md)
