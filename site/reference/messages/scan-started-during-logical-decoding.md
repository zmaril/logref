---
message: "scan started during logical decoding"
slug: scan-started-during-logical-decoding
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/include/access/tableam.h:931"
  - "postgres/src/include/access/tableam.h:1256"
reproduced: false
---

# `scan started during logical decoding`

## What it means

Internal error. A relation scan was initiated in a context that logical decoding does not permit, where only catalog access with a fixed historic snapshot is allowed. Logical decoding runs output plugins under constraints that forbid ordinary table scans.

## When it happens

It fires when output-plugin or decoding code attempts to scan a non-catalog relation while decoding. It usually points to an output plugin doing something it should not, rather than a user query.

## How to fix

This is an internal constraint guard. If it comes from a custom logical-decoding output plugin, that plugin must avoid scanning user tables during decoding; capture the plugin and case and report or fix it there.

## Example

*Illustrative* — a table scan attempted during logical decoding.

```text
ERROR:  scan started during logical decoding
```

## Related

- [replication slot "%s" was not created in this database](./replication-slot-was-not-created-in-this-database.md)
- [system catalog scans with lossy index conditions are not implemented](./system-catalog-scans-with-lossy-index-conditions-are-not-implemented.md)
