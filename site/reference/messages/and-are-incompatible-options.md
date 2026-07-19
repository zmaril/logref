---
message: "%s and %s are incompatible options"
slug: and-are-incompatible-options
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2730"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2770"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2781"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2789"
reproduced: false
---

# `%s and %s are incompatible options`

## What it means

A client tool was given two command-line options that cannot be used together. The placeholders are the two option names. The tool accepts either but rejects the combination because they request conflicting behaviors.

## When it happens

Invoking a tool such as `pg_basebackup` with two flags that contradict each other in one command line.

## How to fix

Drop one of the two named options. Decide which behavior you want and pass only that flag. The message names both, so remove whichever does not apply to your goal.

## Example

*Illustrative* — conflicting pg_basebackup flags.

```sh
pg_basebackup -D out --format=plain --gzip
```

## Related

- [and are mutually exclusive options](./and-are-mutually-exclusive-options.md)
- [cannot specify in binary mode](./cannot-specify-in-binary-mode.md)
