---
message: "could not open toast relation with OID %u (base relation \"%s\")"
slug: could-not-open-toast-relation-with-oid-base-relation
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/reorderbuffer.c:5114"
reproduced: false
---

# `could not open toast relation with OID %u (base relation "%s")`

## What it means

Logical decoding tried to open the TOAST relation that stores the out-of-line values for a base table and could not. The message gives the TOAST relation's OID and the base table name. It needs the TOAST relation to reassemble large column values.

## When it happens

It fires while decoding WAL for logical replication, when a table's TOAST relation cannot be opened — usually the table (or its TOAST) was dropped while its changes were still being decoded, or the catalog is inconsistent.

## How to fix

This is an internal guard in logical decoding. It generally follows a table dropped out from under active decoding. Avoid dropping replicated tables while subscriptions still consume their changes; if it recurs on stable schema, capture the log and report a reproducible case.

## Example

*Illustrative* — a TOAST relation that could not be opened.

```text
ERROR:  could not open toast relation with OID 16460 (base relation "documents")
```

## Related

- [could not open relation with OID (for filenumber)](./could-not-open-relation-with-oid-for-filenumber.md)
- [could not map filenumber to relation OID](./could-not-map-filenumber-to-relation-oid.md)
