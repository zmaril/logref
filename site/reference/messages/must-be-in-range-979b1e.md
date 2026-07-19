---
message: "%s must be in range %u..%u"
slug: must-be-in-range-979b1e
passthrough: false
api: [pg_fatal, pg_log_error]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/bin/pg_test_fsync/pg_test_fsync.c:195"
  - "postgres/src/bin/pg_waldump/pg_waldump.c:1183"
reproduced: false
---

# `%s must be in range %u..%u`

## What it means

A value fell outside an allowed numeric range. The placeholders name the setting and the low and high bounds. It is a bounds check on a configuration value or argument.

## When it happens

It arises when a setting or argument that has explicit minimum and maximum limits is given a value outside them — at startup, on `SET`, or in a function call.

## How to fix

Choose a value within the stated `low..high` range shown in the message. Consult the documentation for the named setting's valid bounds, and correct the configured or supplied value.

## Example

*Illustrative* — a value outside the permitted range.

```text
ERROR:  port must be in range 1..65535
```

## Related

- [must be >= 0](./must-be-0.md)
- [number is out of range](./number-is-out-of-range.md)
