---
message: "%s requires an integer value"
slug: requires-an-integer-value
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/define.c:151"
  - "postgres/src/backend/commands/define.c:160"
  - "postgres/src/backend/commands/define.c:310"
reproduced: false
---

# `%s requires an integer value`

## What it means

An option or definition element that must be an integer was given a non-integer value. The value is parsed as a whole number, and the supplied text did not parse as one.

## When it happens

Passing a non-numeric or fractional value where an integer is required — a command option, or a `DEFINE`-style element in a `CREATE` command that specifies a count or size as an integer.

## How to fix

Supply a whole number. Remove any decimal point, units, or stray characters, and check that a value coming from a variable is numeric before it reaches the option.

## Example

*Illustrative* — a non-integer where an integer is required.

```text
ERROR:  parallel_workers requires an integer value
```

## Related

- [requires a value](./requires-a-value.md)
- [invalid value for option](./invalid-value-for-option.md)
