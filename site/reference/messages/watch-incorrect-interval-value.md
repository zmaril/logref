---
message: "\\watch: incorrect interval value \"%s\""
slug: watch-incorrect-interval-value
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/command.c:3424"
  - "postgres/src/bin/psql/command.c:3490"
reproduced: false
---

# `\watch: incorrect interval value "%s"`

## What it means

The psql `\watch` command was given an interval argument that is not a valid number of seconds.

## When it happens

It arises when running `\watch` with a non-numeric or malformed interval — for example a word, or text that does not parse as a number.

## How to fix

Give `\watch` a numeric interval in seconds, such as `\watch 2` or `\watch 0.5`. Use the `interval=` form only with a valid number, and remove any stray characters.

## Example

*Illustrative* — a bad \watch interval.

```text
ERROR:  \watch: incorrect interval value "fast"
```

## Related

- [\watch: interval value is specified more than once](./watch-interval-value-is-specified-more-than-once.md)
- [value %s out of bounds for option "%s"](./value-out-of-bounds-for-option.md)
