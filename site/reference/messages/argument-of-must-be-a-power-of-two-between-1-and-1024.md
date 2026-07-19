---
message: "argument of %s must be a power of two between 1 and 1024"
slug: argument-of-must-be-a-power-of-two-between-1-and-1024
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/initdb/initdb.c:3497"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:332"
reproduced: false
---

# `argument of %s must be a power of two between 1 and 1024`

## What it means

A tool option that sets a size or count in blocks required a value that is a power of two within a fixed range, and the value given was not. The option only accepts powers of two so the resulting layout aligns correctly. It is raised at FATAL by the tool.

## When it happens

Running initdb or pg_resetwal with an option — such as a WAL-segment or block-related size — set to a value that is not a power of two, or is outside the 1-to-1024 range.

## How to fix

Choose a power of two within the allowed range, such as 1, 2, 4, 8, and so on up to 1024. Check the option's documented units, and pick the nearest valid value for the size you intend.

## Example

*Illustrative* — a non-power-of-two option value.

```text
initdb: error: argument of --wal-segsize must be a power of two between 1 and 1024
```

## Related

- [requires an integer value](./requires-an-integer-value.md)
- [invalid value for option](./invalid-value-for-option.md)
