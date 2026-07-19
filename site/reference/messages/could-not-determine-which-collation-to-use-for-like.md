---
message: "could not determine which collation to use for LIKE"
slug: could-not-determine-which-collation-to-use-for-like
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDETERMINATE_COLLATION
    code: "42P22"
call_sites:
  - "postgres/src/backend/utils/adt/like.c:148"
reproduced: false
---

# `could not determine which collation to use for LIKE`

## What it means

A `LIKE` (or `ILIKE`) comparison involved collatable text whose collation could not be determined. `LIKE` needs a collation to compare characters, and the inputs left it ambiguous.

## When it happens

It happens when a `LIKE` pattern match combines text values of different explicit collations, or uses text with no determinable collation.

## How to fix

Add an explicit `COLLATE` clause to one side of the comparison, for example `col LIKE pattern COLLATE "C"`, so the collation is unambiguous.

## Example

*Illustrative* — a LIKE with conflicting collations.

```sql
SELECT (a COLLATE "C") LIKE (b COLLATE "en_US") FROM t;
-- ERROR:  could not determine which collation to use for LIKE
```

## Related

- [could not determine which collation to use for regular expression](./could-not-determine-which-collation-to-use-for-regular-expression.md)
- [could not determine which collation to use for index expression](./could-not-determine-which-collation-to-use-for-index-expression.md)
