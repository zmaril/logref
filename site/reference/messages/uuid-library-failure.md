---
message: "uuid library failure: %d"
slug: uuid-library-failure
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_EXTERNAL_ROUTINE_EXCEPTION
    code: "38000"
call_sites:
  - "postgres/contrib/uuid-ossp/uuid-ossp.c:315"
  - "postgres/contrib/uuid-ossp/uuid-ossp.c:387"
reproduced: false
---

# `uuid library failure: %d`

## What it means

The UUID support routine called into its underlying library to generate or parse a UUID and the library returned a failure code.

## When it happens

It arises from UUID-generation functions when the platform UUID library (or the fallback) reports an error — a rare environmental condition such as an unavailable entropy source or a library-level fault.

## How to fix

Check the server's UUID/entropy facilities and any relevant extension (`uuid-ossp` versus the built-in `gen_random_uuid()`). Switching to `gen_random_uuid()` avoids the external library; if it recurs, capture the platform details and report it.

## Example

*Illustrative* — a UUID library returning an error.

```text
ERROR:  uuid library failure: -1
```

## Related

- [unexpected number of armor header lines](./unexpected-number-of-armor-header-lines.md)
- [vsnprintf failed: %m with format string "%s"](./vsnprintf-failed-with-format-string.md)
