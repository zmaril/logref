---
message: "could not determine which collation to use for string comparison"
slug: could-not-determine-which-collation-to-use-for-string-comparison
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDETERMINATE_COLLATION
    code: "42P22"
call_sites:
  - "postgres/src/backend/utils/adt/varchar.c:738"
  - "postgres/src/backend/utils/adt/varlena.c:1334"
reproduced: false
---

# `could not determine which collation to use for string comparison`

## What it means

A string comparison involved operands whose collation Postgres could not determine. Comparing text requires a single collation to define ordering, and the expression mixed conflicting explicit collations or left the collation unresolved.

## When it happens

Comparing or ordering text that combines columns with different explicit collations, or a value with no derivable collation, in `ORDER BY`, `<`/`>`, `GROUP BY`, or similar.

## How to fix

Apply an explicit `COLLATE` clause to set the collation for the comparison, for example `a COLLATE "en_US" < b`. Make sure the compared expressions resolve to one collation.

## Example

*Illustrative* — a comparison with conflicting collations.

```sql
SELECT * FROM t ORDER BY a COLLATE "C", b COLLATE "en_US";  -- mixed in one comparison
-- ERROR:  could not determine which collation to use for string comparison
```

## Related

- [could not determine which collation to use for ILIKE](./could-not-determine-which-collation-to-use-for-ilike.md)
- [could not convert string to UTF-16 error code](./could-not-convert-string-to-utf-16-error-code.md)
