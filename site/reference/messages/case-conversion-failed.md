---
message: "case conversion failed: %s"
slug: case-conversion-failed
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/pg_locale_icu.c:658"
  - "postgres/src/backend/utils/adt/pg_locale_icu.c:672"
  - "postgres/src/backend/utils/adt/pg_locale_icu.c:686"
  - "postgres/src/backend/utils/adt/pg_locale_icu.c:700"
  - "postgres/src/backend/utils/adt/pg_locale_icu.c:991"
reproduced: false
---

# `case conversion failed: %s`

## What it means

An ICU-based upper/lower/initcap case conversion failed inside the collation provider. The placeholder is the underlying ICU error text. The conversion could not complete for the given string and locale.

## When it happens

Running `upper()`, `lower()`, or `initcap()` with an ICU collation when ICU returns an error — for example on malformed input for the encoding, or an ICU library problem.

## How to fix

Read the ICU error text in the message. Confirm the input is valid text in the database encoding. If it points to an ICU library issue, check that the server's ICU version is intact and consistent; a corrupt or mismatched ICU install can cause conversion failures. Testing with a libc collation isolates whether ICU is the cause.

## Example

*Illustrative* — an ICU case conversion failure.

```text
ERROR:  case conversion failed: U_ILLEGAL_ARGUMENT_ERROR
```

## Related

- [could not determine which collation to use for function](./could-not-determine-which-collation-to-use-for-function.md)
- [invalid collation](./invalid-collation.md)
