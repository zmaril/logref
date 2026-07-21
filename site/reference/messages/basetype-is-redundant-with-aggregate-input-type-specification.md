---
message: "basetype is redundant with aggregate input type specification"
slug: basetype-is-redundant-with-aggregate-input-type-specification
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_FUNCTION_DEFINITION
    code: "42P13"
call_sites:
  - "postgres/src/backend/commands/aggregatecmds.c:302"
reproduced: true
---

# `basetype is redundant with aggregate input type specification`

## What it means

A `CREATE AGGREGATE` command gave both the old-style `BASETYPE` parameter and the modern input-type argument list. The two describe the same thing, so specifying both is contradictory.

## When it happens

It occurs when `CREATE AGGREGATE` mixes the legacy `BASETYPE = ...` syntax with the current form that names input types directly in the argument list.

## How to fix

Use one form. Prefer the modern syntax that lists the input types in the argument list and drop `BASETYPE`. The `BASETYPE` keyword remains only for backward compatibility with the old single-argument syntax.

## Example

*Reproduced* — captured from `reproducers/scenarios/45_create_routines.sql`.

```sql
CREATE AGGREGATE repro.agg_bt(int) (BASETYPE = int, SFUNC = int4pl, STYPE = int);
```

Produces:

```text
ERROR:  basetype is redundant with aggregate input type specification
```

## Related

- [btree skip support functions must accept type internal](./btree-skip-support-functions-must-accept-type-internal.md)
- [both default and identity specified for column of table](./both-default-and-identity-specified-for-column-of-table.md)
