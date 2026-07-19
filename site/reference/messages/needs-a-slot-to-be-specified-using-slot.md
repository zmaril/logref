---
message: "%s needs a slot to be specified using --slot"
slug: needs-a-slot-to-be-specified-using-slot
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2722"
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:774"
reproduced: false
---

# `%s needs a slot to be specified using --slot`

## What it means

A replication tool action requires a replication slot, but none was named. The placeholder identifies the tool or action. The `--slot` option must be provided.

## When it happens

It arises with tools such as `pg_receivewal` or `pg_recvlogical` when an action that reads from or manages a slot is invoked without `--slot`.

## How to fix

Pass `--slot slotname` naming the replication slot to use. Create the slot first if it does not exist (with `--create-slot` or on the server), and confirm the name matches an existing slot.

## Example

*Illustrative* — a slot action without --slot.

```text
ERROR:  pg_recvlogical needs a slot to be specified using --slot
```

## Related

- [may only be specified with --create-slot](./may-only-be-specified-with-create-slot.md)
- [no output directory specified](./no-output-directory-specified.md)
