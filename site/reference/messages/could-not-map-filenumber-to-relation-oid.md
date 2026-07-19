---
message: "could not map filenumber \"%s\" to relation OID"
slug: could-not-map-filenumber-to-relation-oid
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/reorderbuffer.c:2344"
reproduced: false
---

# `could not map filenumber "%s" to relation OID`

## What it means

Logical decoding tried to translate a relation's on-disk file number back to its catalog OID while reassembling a transaction and could not. It needs the OID to know which table a change belongs to.

## When it happens

It fires while decoding WAL for logical replication, when a file number in the stream maps to no current relation — usually because the table was dropped, or the decoding state is inconsistent with the catalog.

## How to fix

This is an internal guard in logical decoding. It generally follows a table that was dropped while its changes were still being decoded, or a catalog inconsistency. Make sure replicated tables are not dropped out from under active subscriptions; if it recurs on stable schema, capture the log and report a reproducible case.

## Example

*Illustrative* — a file number with no matching relation.

```text
ERROR:  could not map filenumber "16451" to relation OID
```

## Related

- [could not open relation with OID (for filenumber)](./could-not-open-relation-with-oid-for-filenumber.md)
- [could not open toast relation with OID (base relation)](./could-not-open-toast-relation-with-oid-base-relation.md)
