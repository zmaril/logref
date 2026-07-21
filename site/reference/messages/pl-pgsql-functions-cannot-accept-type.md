---
message: "PL/pgSQL functions cannot accept type %s"
slug: pl-pgsql-functions-cannot-accept-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_comp.c:331"
  - "postgres/src/pl/plpgsql/src/pl_handler.c:494"
reproduced: false
---

# `PL/pgSQL functions cannot accept type %s`

## What it means

A PL/pgSQL function was declared with a parameter of a type that the language cannot receive as an argument. The placeholder is the type. A few pseudo-types (such as certain internal or trigger-only types) cannot be passed into PL/pgSQL.

## When it happens

It arises at `CREATE FUNCTION ... LANGUAGE plpgsql` when an argument is declared as a type PL/pgSQL does not support as input — for example `internal`, or another pseudo-type used outside its valid role.

## How to fix

Change the argument to a supported type. If you need to handle values of such a type, do it in a C-language function, or restructure so PL/pgSQL receives an ordinary SQL type instead.

## Example

*Illustrative* — a PL/pgSQL argument of an unsupported pseudo-type.

```text
ERROR:  PL/pgSQL functions cannot accept type internal
```

## Related

- [PL/pgSQL functions cannot return type %s](./pl-pgsql-functions-cannot-return-type.md)
- [SETOF type not allowed for operator argument](./setof-type-not-allowed-for-operator-argument.md)
