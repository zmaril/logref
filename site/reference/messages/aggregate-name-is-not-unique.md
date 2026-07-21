---
message: "aggregate name \"%s\" is not unique"
slug: aggregate-name-is-not-unique
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_AMBIGUOUS_FUNCTION
    code: "42725"
call_sites:
  - "postgres/src/backend/parser/parse_func.c:2604"
reproduced: false
---

# `aggregate name "%s" is not unique`

## What it means

An aggregate was referenced by a name that matches more than one aggregate, and the context did not give enough argument-type information to choose between them.

## When it happens

It occurs when altering, dropping, or otherwise referring to an aggregate by bare name where overloads exist, for example `ALTER AGGREGATE myagg RENAME ...` without an argument list.

## How to fix

Disambiguate by giving the argument type list: `ALTER AGGREGATE myagg(int) ...`. List the overloads with `\da myagg` in psql, then reference the exact signature you mean.

## Example

*Illustrative* — an ambiguous aggregate reference.

```sql
DROP AGGREGATE myagg;  -- ERROR:  aggregate name "myagg" is not unique
```

## Related

- [aggregate %s does not exist](./aggregate-does-not-exist-fab492.md)
- [access method already exists](./access-method-already-exists.md)
