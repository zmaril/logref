---
message: "SETOF type not allowed for operator argument"
slug: setof-type-not-allowed-for-operator-argument
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/commands/operatorcmds.c:111"
  - "postgres/src/backend/commands/operatorcmds.c:119"
reproduced: false
---

# `SETOF type not allowed for operator argument`

## What it means

An operator was defined with a `SETOF` type as one of its argument types. Operators take scalar (single-value) argument types; a set-returning type is not permitted there.

## When it happens

It arises from `CREATE OPERATOR` whose left or right argument type is declared `SETOF something`.

## How to fix

Declare the operator's arguments as ordinary (non-`SETOF`) types. If you need set-returning behavior, use a function rather than an operator; operators must operate on individual values.

## Example

*Illustrative* — a SETOF operator argument.

```text
ERROR:  SETOF type not allowed for operator argument
```

## Related

- [postfix operators are not supported](./postfix-operators-are-not-supported.md)
- [PL/pgSQL functions cannot accept type %s](./pl-pgsql-functions-cannot-accept-type.md)
