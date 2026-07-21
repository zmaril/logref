---
message: "%s failed: %s"
slug: failed-6dc129
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/pg_locale_icu.c:950"
  - "postgres/src/backend/utils/adt/pg_locale_icu.c:962"
  - "postgres/src/backend/utils/adt/pg_locale_icu.c:1234"
  - "postgres/src/backend/utils/adt/pg_locale_icu.c:1254"
reproduced: false
---

# `%s failed: %s`

## What it means

A generic failure wrapper: the first placeholder names the operation that failed and the second carries the underlying error text. Here it comes from the ICU collation-provider path, reporting that a named ICU operation returned an error.

## When it happens

An ICU-backed operation (collation open, transform, or similar) returned an error, surfaced through this generic wrapper with the operation name and ICU's message.

## How to fix

Read both parts: the operation name tells you what was attempted, the trailing text is the real cause. For ICU failures, confirm the locale/collation is valid and the server's ICU library is intact and consistent. Testing the same operation with a libc collation isolates whether ICU is the source.

## Example

*Illustrative* — a wrapped ICU failure.

```text
ERROR:  ucol_open failed: U_MISSING_RESOURCE_ERROR
```

## Related

- [case conversion failed](./case-conversion-failed.md)
- [could not determine which collation to use for function](./could-not-determine-which-collation-to-use-for-function.md)
