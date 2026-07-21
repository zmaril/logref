---
message: "invalid name syntax"
slug: invalid-name-syntax
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_NAME
    code: "42602"
call_sites:
  - "postgres/src/backend/utils/adt/varlena.c:2734"
  - "postgres/src/backend/utils/adt/varlena.c:2739"
reproduced: false
---

# `invalid name syntax`

## What it means

A value being converted to the `name` type (or parsed as a qualified name) has a syntax the parser rejects — for example the wrong number of dot-separated parts for the context.

## When it happens

It arises from functions that parse identifiers, such as `parse_ident()` or textual regclass/regproc-style casts, when the input is not a valid identifier or qualified name.

## How to fix

Provide a syntactically valid name. For qualified names, supply the expected number of components (for example `schema.object`) and quote parts that contain special characters. `parse_ident` expects a well-formed dotted identifier.

## Example

*Illustrative* — a malformed qualified name.

```sql
SELECT parse_ident('a..b');  -- invalid name syntax
```

## Related

- [is not a valid operator name](./is-not-a-valid-operator-name.md)
- [invalid option name must not contain](./invalid-option-name-must-not-contain.md)
