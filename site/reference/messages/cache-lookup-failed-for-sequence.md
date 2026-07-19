---
message: "cache lookup failed for sequence %u"
slug: cache-lookup-failed-for-sequence
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/sequence.c:277"
  - "postgres/src/backend/commands/sequence.c:468"
  - "postgres/src/backend/commands/sequence.c:580"
  - "postgres/src/backend/commands/sequence.c:681"
  - "postgres/src/backend/commands/sequence.c:969"
  - "postgres/src/backend/commands/sequence.c:1720"
  - "postgres/src/backend/commands/sequence.c:1768"
  - "postgres/src/backend/replication/logical/sequencesync.c:346"
reproduced: false
---

# `cache lookup failed for sequence %u`

## What it means

Internal error. A sequence's catalog row could not be found by OID. The placeholder is the sequence OID. Something referenced the sequence but the row is gone.

## When it happens

A concurrent `DROP SEQUENCE` (including the automatic drop of an owned sequence when its table or column is dropped) while another operation held the OID, or catalog inconsistency. It also appears in sequence-synchronization paths for logical replication.

## How to fix

If it coincides with concurrent DDL that drops the sequence or its owning column, retry — the sequence is gone. If it recurs, inspect `pg_class`/`pg_sequence` for the OID; a missing row is corruption. Report reproducible cases.

## Example

*Illustrative* — a sequence dropped with its owning column.

```text
ERROR:  cache lookup failed for sequence 16820
```

## Related

- [is not a sequence](./is-not-a-sequence.md)
- [cache lookup failed for relation](./cache-lookup-failed-for-relation-0e5774.md)
