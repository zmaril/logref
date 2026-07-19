---
message: "could not determine which collation to use for %s function"
slug: could-not-determine-which-collation-to-use-for-function
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDETERMINATE_COLLATION
    code: "42P22"
call_sites:
  - "postgres/src/backend/utils/adt/formatting.c:1634"
  - "postgres/src/backend/utils/adt/formatting.c:1698"
  - "postgres/src/backend/utils/adt/formatting.c:1762"
  - "postgres/src/backend/utils/adt/formatting.c:1826"
reproduced: false
---

# `could not determine which collation to use for %s function`

## What it means

A function that depends on collation was called with operands whose collations conflict, so Postgres cannot pick one. The placeholder is the function name. When multiple explicit collations meet with no rule to choose between them, the collation is indeterminate.

## When it happens

Calling a collation-sensitive function (`lower`, `upper`, formatting, comparisons) on a mix of values with different explicit collations, or on an expression whose collation could not be derived.

## How to fix

Add an explicit `COLLATE` clause to fix the collation — for example `func(col COLLATE "en_US")`. Ensure the operands share a determinable collation, and avoid combining columns with conflicting explicit collations without resolving them.

## Example

*Illustrative* — a collation conflict in a function call.

```sql
SELECT lower(a || b);  -- a and b have different explicit collations
```

## Related

- [could not determine which collation to use for string hashing](./could-not-determine-which-collation-to-use-for-string-hashing.md)
- [case conversion failed](./case-conversion-failed.md)
