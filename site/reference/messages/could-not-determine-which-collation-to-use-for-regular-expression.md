---
message: "could not determine which collation to use for regular expression"
slug: could-not-determine-which-collation-to-use-for-regular-expression
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDETERMINATE_COLLATION
    code: "42P22"
call_sites:
  - "postgres/src/backend/regex/regc_pg_locale.c:45"
reproduced: false
---

# `could not determine which collation to use for regular expression`

## What it means

A regular-expression operation involved collatable text whose collation could not be determined. Regex matching uses a collation for character-class behavior, and the inputs left it ambiguous.

## When it happens

It happens with regex operators and functions (`~`, `regexp_match`, and friends) when the text combines different explicit collations, or uses text with no determinable collation.

## How to fix

Add an explicit `COLLATE` clause to the text being matched, for example `col ~ pattern COLLATE "C"`, so the collation is unambiguous.

## Example

*Illustrative* — a regex match with conflicting collations.

```sql
SELECT (a COLLATE "C") ~ (b COLLATE "en_US") FROM t;
-- ERROR:  could not determine which collation to use for regular expression
```

## Related

- [could not determine which collation to use for LIKE](./could-not-determine-which-collation-to-use-for-like.md)
- [could not compare Unicode strings](./could-not-compare-unicode-strings.md)
