---
message: "cannot specify both \"%s\" and \"%s\""
slug: cannot-specify-both-and-f3ca8a
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/statistics/attribute_stats.c:192"
reproduced: false
---

# `cannot specify both "%s" and "%s"`

## What it means

A command was given two options that cannot be used together. The two names in the message are the conflicting options. This is a generic guard used across several commands and utilities when a pair of settings is mutually exclusive.

## When it happens

It occurs when a statement or client tool receives two flags or clauses that contradict each other, for example a pair of output or mode options that each fully determine the same behavior.

## How to fix

Keep one of the two options and drop the other. Decide which behavior you want, remove the conflicting name from the command or statement, and rerun.

## Example

*Illustrative* — two mutually exclusive options supplied.

```text
ERROR:  cannot specify both "a" and "b"
```

## Related

- [cannot specify both PARSER and COPY options](./cannot-specify-both-parser-and-copy-options.md)
- [cannot specify both format and backup target](./cannot-specify-both-format-and-backup-target.md)
