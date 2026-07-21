---
message: "collations with different collate and ctype values are not supported on this platform"
slug: collations-with-different-collate-and-ctype-values-are-not-supported-on-this
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/adt/pg_locale_libc.c:911"
reproduced: false
---

# `collations with different collate and ctype values are not supported on this platform`

## What it means

A `CREATE COLLATION` set different `LC_COLLATE` and `LC_CTYPE` values, but the platform's locale library cannot support a collation whose sort order and character classification come from different locales.

## When it happens

It occurs on `CREATE COLLATION ... (lc_collate = '...', lc_ctype = '...')` with two different locale values on a platform that requires them to match.

## How to fix

Use the same value for `LC_COLLATE` and `LC_CTYPE`, or set a single `locale` for the collation. If you need split behavior, use the ICU provider where the platform supports it.

## Example

*Illustrative* — mismatched collate and ctype.

```text
ERROR:  collations with different collate and ctype values are not supported on this platform
```

## Related

- [collation has no actual version but a version was recorded](./collation-has-no-actual-version-but-a-version-was-recorded.md)
- [collation attribute not recognized](./collation-attribute-not-recognized.md)
