---
message: "could not open relation with OID %u (for filenumber \"%s\")"
slug: could-not-open-relation-with-oid-for-filenumber
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/reorderbuffer.c:2351"
reproduced: false
---

# `could not open relation with OID %u (for filenumber "%s")`

## What it means

Logical decoding mapped a file number to a relation OID but then could not open the relation. The message gives both the OID and the file number. It opens the relation to interpret the changes it is decoding.

## When it happens

It fires while decoding WAL for logical replication, when the relation the OID names cannot be opened — usually because the table was dropped while its changes were still being decoded, or the catalog is inconsistent.

## How to fix

This is an internal guard in logical decoding. It generally follows a table dropped out from under active decoding. Avoid dropping replicated tables while subscriptions are still consuming their changes; if it recurs on stable schema, capture the log and report a reproducible case.

## Example

*Illustrative* — a relation OID that could not be opened.

```text
ERROR:  could not open relation with OID 16451 (for filenumber "16451")
```

## Related

- [could not map filenumber to relation OID](./could-not-map-filenumber-to-relation-oid.md)
- [could not open toast relation with OID (base relation)](./could-not-open-toast-relation-with-oid-base-relation.md)
