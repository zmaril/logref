---
message: "creating replication slot \"%s\""
slug: creating-replication-slot
passthrough: false
api: [pg_log_info]
level: [INFO]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:889"
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:1005"
reproduced: false
---

# `creating replication slot "%s"`

## What it means

An informational message that a tool or command is creating a replication slot with the given name.

## When it happens

It arises from `pg_basebackup`, `pg_receivewal`, `pg_recvlogical`, or `CREATE SUBSCRIPTION` when they create a slot as part of setup, reporting progress.

## Is this a problem?

No action is needed. It is progress output confirming slot creation. If you did not expect a slot to be created, review the tool's options that control slot creation.

## Example

*Illustrative* — creating a replication slot.

```text
INFO:  creating replication slot "sub1"
```

## Related

- [dropping replication slot "%s"](./dropping-replication-slot.md)
- [could not synchronize replication slot "%s"](./could-not-synchronize-replication-slot.md)
