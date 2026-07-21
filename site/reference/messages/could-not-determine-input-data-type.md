---
message: "could not determine input data type"
slug: could-not-determine-input-data-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/array_userfuncs.c:117"
  - "postgres/src/backend/utils/adt/array_userfuncs.c:564"
  - "postgres/src/backend/utils/adt/array_userfuncs.c:941"
  - "postgres/src/backend/utils/adt/json.c:609"
  - "postgres/src/backend/utils/adt/json.c:716"
  - "postgres/src/backend/utils/adt/json.c:767"
  - "postgres/src/backend/utils/adt/jsonb.c:1059"
  - "postgres/src/backend/utils/adt/jsonb.c:1101"
  - "postgres/src/backend/utils/adt/jsonb.c:1495"
  - "postgres/src/backend/utils/adt/jsonb.c:1613"
  - "postgres/src/backend/utils/adt/jsonb.c:1623"
reproduced: false
---

# `could not determine input data type`

## What it means

A polymorphic or variadic function could not infer the type of an input because it was passed as an untyped `NULL` or `unknown` literal with no context. Functions like `array_agg`, `json_build_array`, or ones with `anyelement`/`anyarray` parameters need to know the argument's type, and none could be determined.

## When it happens

Calling such a function with a bare `NULL` or an unadorned string literal where the type is ambiguous — for example `SELECT array_agg(NULL)` with no type annotation, or a polymorphic function fed only untyped literals.

## How to fix

Add an explicit cast so the type is known: `array_agg(NULL::int)`, `json_build_array('x'::text)`. Any untyped `NULL`/literal in a polymorphic argument needs annotation. This is the standard fix — tell Postgres the type it cannot infer.

## Example

*Illustrative* — aggregating an untyped NULL.

```sql
SELECT array_agg(NULL);
```

Produces:

```text
ERROR:  could not determine polymorphic type because input has type unknown
```

## Related

- [could not determine polymorphic type because input has type](./could-not-determine-polymorphic-type-because-input-has-type-9d5653.md)
- [could not find array type for data type %s](./could-not-find-array-type-for-data-type.md)
