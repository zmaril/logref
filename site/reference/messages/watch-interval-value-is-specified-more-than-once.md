---
message: "\\watch: interval value is specified more than once"
slug: watch-interval-value-is-specified-more-than-once
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/command.c:3414"
  - "postgres/src/bin/psql/command.c:3480"
reproduced: false
---

# `\watch: interval value is specified more than once`

## What it means

The psql `\watch` command was given an interval more than once — both positionally and with the `interval=` keyword, or the keyword twice.

## When it happens

It arises when a `\watch` invocation supplies the interval through two different arguments, so psql cannot tell which to use.

## How to fix

Specify the interval once. Use either the positional form (`\watch 2`) or the `interval=` keyword (`\watch interval=2`), not both, and do not repeat the keyword.

## Example

*Illustrative* — a duplicated \watch interval.

```text
ERROR:  \watch: interval value is specified more than once
```

## Related

- [\watch: incorrect interval value "%s"](./watch-incorrect-interval-value.md)
- [value %s out of bounds for option "%s"](./value-out-of-bounds-for-option.md)
