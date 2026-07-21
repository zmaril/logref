---
message: "at least one action needs to be specified"
slug: at-least-one-action-needs-to-be-specified
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:905"
reproduced: false
---

# `at least one action needs to be specified`

## What it means

A command that requires at least one action or sub-clause was given none, so there is nothing for it to do.

## When it happens

It occurs with commands whose grammar allows several actions but requires at least one — for example an `ALTER` or `MERGE`-style statement invoked with an empty action list.

## How to fix

Add at least one action to the command. Consult the syntax for the statement and include a concrete sub-command (a `SET`, an `ADD`, a `WHEN` clause, and so on) rather than an empty body.

## Example

*Illustrative* — a command with no action specified.

```text
ERROR:  at least one action needs to be specified
```

## Related

- [at end of input](./at-end-of-input.md)
- [alter action cannot be performed on relation](./alter-action-cannot-be-performed-on-relation.md)
