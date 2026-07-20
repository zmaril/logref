---
message: "could not determine which collation to use for ILIKE"
slug: could-not-determine-which-collation-to-use-for-ilike
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDETERMINATE_COLLATION
    code: "42P22"
call_sites:
  - "postgres/src/backend/utils/adt/like.c:179"
  - "postgres/src/backend/utils/adt/like_support.c:1104"
reproduced: false
---

# `could not determine which collation to use for ILIKE`

## What it means

An `ILIKE` (case-insensitive pattern match) involved text whose collation Postgres could not determine. `ILIKE` needs a collation to define case folding, and the operands supplied conflicting or indeterminate collations.

## When it happens

Using `ILIKE` on an expression combining columns or values with different explicit collations, or on a value whose collation is unresolved (for example a literal without a derivable collation in context).

## How to fix

Add an explicit `COLLATE` clause to fix the collation, for example `col COLLATE "en_US" ILIKE pattern`. Ensure the operands share a determinable collation so case-insensitive matching is well defined.

## Example

*Illustrative* — ILIKE with an indeterminate collation.

```sql
SELECT a ILIKE b FROM t;  -- a, b have different explicit collations
-- ERROR:  could not determine which collation to use for ILIKE
```

## Related

- [could not determine which collation to use for string comparison](./could-not-determine-which-collation-to-use-for-string-comparison.md)
- [collation failed](./collation-failed.md)
