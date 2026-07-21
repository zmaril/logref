---
message: "could not determine polymorphic type because input has type %s"
slug: could-not-determine-polymorphic-type-because-input-has-type-ede818
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/parse_coerce.c:2507"
reproduced: false
---

# `could not determine polymorphic type because input has type %s`

## What it means

PostgreSQL could not resolve a polymorphic type because an input had a type that does not fit the polymorphic family. The `%s` names the input type. The type could not be pinned down.

## When it happens

It happens during type resolution when a value supplied for a polymorphic parameter (such as `anyarray` or `anyrange`) has a type incompatible with that family — for example a plain scalar where an array is required.

## How to fix

Supply an input whose type matches the polymorphic family the function expects, casting if needed. Check the function's signature to see which family (element, array, range, or multirange) each argument belongs to.

## Example

*Illustrative* — a scalar where an array-family input is required.

```text
ERROR:  could not determine polymorphic type because input has type unknown
```

## Related

- [could not determine actual type of argument declared](./could-not-determine-actual-type-of-argument-declared.md)
- [could not determine data type of concat() input](./could-not-determine-data-type-of-concat-input.md)
