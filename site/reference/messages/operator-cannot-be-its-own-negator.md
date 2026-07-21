---
message: "operator cannot be its own negator"
slug: operator-cannot-be-its-own-negator
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/catalog/pg_operator.c:443"
  - "postgres/src/backend/commands/operatorcmds.c:631"
reproduced: true
---

# `operator cannot be its own negator`

## What it means

A `CREATE OPERATOR` named the operator itself as its `NEGATOR`. An operator's negator must be a different operator that yields the opposite boolean result.

## When it happens

It arises from `CREATE OPERATOR name (... NEGATOR = name ...)` where the negator refers back to the operator being defined.

## How to fix

Point `NEGATOR` at a distinct operator whose result is the logical negation of this one (for example `<>` as the negator of `=`), or omit the clause. An operator cannot be its own negator.

## Example

*Reproduced* — captured from `reproducers/scenarios/45_create_routines.sql`.

```sql
CREATE OPERATOR repro.=?= (LEFTARG = int, RIGHTARG = int, PROCEDURE = int4eq, NEGATOR = OPERATOR(repro.=?=));
```

Produces:

```text
ERROR:  operator cannot be its own negator
```

## Related

- [operator attribute not recognized](./operator-attribute-not-recognized.md)
- [missing oprcode for operator](./missing-oprcode-for-operator.md)
