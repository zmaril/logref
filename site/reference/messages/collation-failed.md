---
message: "collation failed: %s"
slug: collation-failed
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/pg_locale_icu.c:760"
  - "postgres/src/backend/utils/adt/pg_locale_icu.c:780"
reproduced: false
---

# `collation failed: %s`

## What it means

A string comparison or sort using ICU failed inside the collation provider. The placeholder is the underlying ICU error text. The collation library returned an error while comparing or transforming a string, rather than a normal ordering result.

## When it happens

Comparing or ordering text with an ICU collation when ICU reports a failure — from malformed input for the locale, an ICU version issue, or an unusual code point sequence the collation cannot process.

## How to fix

Check the ICU error detail for the specific cause. Validate the text data for the collation's encoding, ensure the server's ICU version is consistent with how the collation was defined, and consider rebuilding indexes if an ICU upgrade changed collation behavior. For persistent cases, isolate the offending value and report it with the ICU detail.

## Example

*Illustrative* — ICU reporting a comparison failure.

```text
ERROR:  collation failed: U_ILLEGAL_ARGUMENT_ERROR
```

## Related

- [collation already exists](./collation-already-exists.md)
- [could not convert locale name to language tag](./could-not-convert-locale-name-to-language-tag.md)
