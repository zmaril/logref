---
message: "vsnprintf failed: %m with format string \"%s\""
slug: vsnprintf-failed-with-format-string
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/misc/guc.c:5901"
  - "postgres/src/common/psprintf.c:113"
reproduced: false
---

# `vsnprintf failed: %m with format string "%s"`

## What it means

Internal error. A call into the C library's `vsnprintf` to format a string failed, and the errno string plus the format string are reported.

## When it happens

It fires from internal string-formatting paths when the underlying formatting call returns an error — a rare environmental or memory condition, not ordinary SQL.

## How to fix

This is an internal guard. The reported errno (`%m`) is the primary clue; check for out-of-memory or an invalid format encountered internally, and report a reproducible case with the surrounding operation.

## Example

*Illustrative* — a formatting-call failure.

```text
ERROR:  vsnprintf failed: Cannot allocate memory with format string "%s = %s"
```

## Related

- [uuid library failure: %d](./uuid-library-failure.md)
- [unrecognized format() type specifier "%.*s"](./unrecognized-format-type-specifier.md)
