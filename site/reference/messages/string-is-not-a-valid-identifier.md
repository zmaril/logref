---
message: "string is not a valid identifier: \"%s\""
slug: string-is-not-a-valid-identifier
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/misc.c:868"
  - "postgres/src/backend/utils/adt/misc.c:882"
  - "postgres/src/backend/utils/adt/misc.c:921"
  - "postgres/src/backend/utils/adt/misc.c:927"
  - "postgres/src/backend/utils/adt/misc.c:933"
  - "postgres/src/backend/utils/adt/misc.c:956"
reproduced: false
---

# `string is not a valid identifier: "%s"`

## What it means

A string passed where an SQL identifier was expected could not be parsed as one. The placeholder is the offending text. This comes from functions like `parse_ident()` that split a qualified name into its parts and validate each against identifier rules.

## When it happens

Calling `parse_ident()` (or similar) on a value that is not a well-formed identifier — empty, containing illegal characters, unbalanced quotes, or too many dotted components.

## How to fix

Pass a syntactically valid identifier. If the name legitimately contains special characters or spaces, double-quote it within the string (`"weird name"`). Use `parse_ident(..., strictmode => false)` if you want trailing junk tolerated, and `quote_ident()` to build a safe identifier from arbitrary text.

## Example

*Illustrative* — an unparseable identifier.

```sql
SELECT parse_ident('1 + 1');
```

## Related

- [role name is reserved](./role-name-is-reserved.md)
- [invalid extension name](./invalid-extension-name.md)
