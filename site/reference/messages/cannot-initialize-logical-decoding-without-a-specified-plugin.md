---
message: "cannot initialize logical decoding without a specified plugin"
slug: cannot-initialize-logical-decoding-without-a-specified-plugin
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/logical.c:352"
reproduced: false
---

# `cannot initialize logical decoding without a specified plugin`

## What it means

An internal guard fired: logical decoding setup began without an output plugin name. Every logical replication slot decodes changes through a named output plugin, and this path had none supplied.

## When it happens

It is reached when slot creation or decoding startup reaches the initialization code with an empty plugin name. It reflects a coding issue in the caller rather than a normal user action, since the plugin is required at slot-create time.

## How to fix

There is no user-level fix. When creating a logical slot, always name an output plugin (for example `pgoutput` or `test_decoding`). If it appears with a valid create call, capture the client or extension driving decoding and report it.

## Example

*Illustrative* — decoding started with no plugin.

```text
ERROR:  cannot initialize logical decoding without a specified plugin
```

## Related

- [cannot get the latest WAL position from the publisher](./cannot-get-the-latest-wal-position-from-the-publisher.md)
- [cannot manipulate replication origins during recovery](./cannot-manipulate-replication-origins-during-recovery.md)
