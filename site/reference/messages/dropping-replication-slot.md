---
message: "dropping replication slot \"%s\""
slug: dropping-replication-slot
passthrough: false
api: [pg_log_info]
level: [INFO]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:878"
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:995"
reproduced: false
---

# `dropping replication slot "%s"`

## What it means

An informational message that a tool or command is dropping a replication slot with the given name.

## When it happens

It arises from tools and commands that remove a slot as part of cleanup or teardown (for example dropping a subscription's slot), reporting progress.

## Is this a problem?

No action is needed. It is progress output confirming slot removal. If you did not expect the slot to be dropped, review the tool or command's options.

## Example

*Illustrative* — dropping a replication slot.

```text
INFO:  dropping replication slot "sub1"
```

## Related

- [creating replication slot "%s"](./creating-replication-slot.md)
- [Drop this replication slot soon to avoid retention of WAL files.](./drop-this-replication-slot-soon-to-avoid-retention-of-wal-files.md)
