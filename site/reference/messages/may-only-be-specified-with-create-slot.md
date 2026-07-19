---
message: "%s may only be specified with --create-slot"
slug: may-only-be-specified-with-create-slot
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:935"
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:942"
reproduced: false
---

# `%s may only be specified with --create-slot`

## What it means

A command-line option to a replication tool was used without `--create-slot`, but it only applies when creating a slot. The placeholder names the option.

## When it happens

It arises with tools like `pg_receivewal` or `pg_recvlogical` when a slot-creation-only option (such as a two-phase or output-plugin option) is passed without the `--create-slot` action.

## How to fix

Add `--create-slot` when using options that configure a new slot, or drop those options when performing a different action. Review the tool's help for which options require slot creation.

## Example

*Illustrative* — a create-only option without --create-slot.

```text
ERROR:  --two-phase may only be specified with --create-slot
```

## Related

- [needs a slot to be specified using --slot](./needs-a-slot-to-be-specified-using-slot.md)
- [no output directory specified](./no-output-directory-specified.md)
