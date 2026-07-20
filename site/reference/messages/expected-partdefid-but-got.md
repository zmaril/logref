---
message: "expected partdefid %u, but got %u"
slug: expected-partdefid-but-got
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/partitioning/partdesc.c:295"
reproduced: false
---

# `expected partdefid %u, but got %u`

## What it means

An internal consistency check in partition-descriptor building. The default-partition identifier read from the catalog did not match the OID the code expected. The placeholders are the expected and actual OIDs.

## When it happens

It fires while the server builds a partitioned table's in-memory partition descriptor if the recorded default-partition OID is inconsistent. In normal operation these stay in agreement.

## How to fix

This is an internal invariant that usually reflects catalog inconsistency or a concurrency bug rather than a user mistake. If it followed a crash or interrupted DDL, investigate the partitioned table's catalog entries. Capture the table definition and the surrounding operations and report it.

## Example

*Illustrative* — the message as logged.

```
ERROR:  expected partdefid 16480, but got 16490
```

## Related

- [expected PartitionBoundSpec for relation](./expected-partitionboundspec-for-relation.md)
- [expected PartitionBoundSpec](./expected-partitionboundspec.md)
