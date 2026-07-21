---
message: "cannot use the \"%s\" option with the \"%s\" option"
slug: cannot-use-the-option-with-the-option
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/scripts/vacuumdb.c:290"
  - "postgres/src/bin/scripts/vacuumdb.c:298"
reproduced: false
---

# `cannot use the "%s" option with the "%s" option`

## What it means

A command-line tool was given two options that cannot be combined. The placeholders name the two conflicting options. This message comes from client programs such as `vacuumdb` when mutually exclusive flags are passed together.

## When it happens

Invoking a tool like `vacuumdb` with flags that contradict each other — for example an option that selects one mode alongside one that selects an incompatible mode.

## How to fix

Pass only one of the conflicting options. Check the tool's `--help` to see which flags are mutually exclusive, and split the work into separate invocations if you need both behaviors.

## Example

*Illustrative* — two incompatible vacuumdb options.

```text
vacuumdb: fatal: cannot use the "full" option with the "analyze-only" option
```

## Related

- [cannot be specified multiple times](./cannot-be-specified-multiple-times.md)
- [could not connect to database](./could-not-connect-to-database-ec9b7c.md)
