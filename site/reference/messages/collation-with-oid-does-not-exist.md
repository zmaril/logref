---
message: "collation with OID %u does not exist"
slug: collation-with-oid-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/collationcmds.c:553"
reproduced: false
---

# `collation with OID %u does not exist`

## What it means

A lookup for a collation by its object identifier found no matching catalog row. The referenced collation OID does not exist, usually because the collation was dropped or a cached reference went stale.

## When it happens

It is reached from catalog lookups during planning or execution when a stored collation OID no longer resolves, for example after the collation was dropped concurrently.

## How to fix

Recreate or restore the missing collation, or update objects that reference it to a collation that exists. If a query cached a dropped collation, start a fresh session so the reference is re-resolved.

## Example

*Illustrative* — a missing collation OID.

```text
ERROR:  collation with OID 12345 does not exist
```

## Related

- [collation for encoding does not exist](./collation-for-encoding-does-not-exist.md)
- [collation has no actual version but a version was recorded](./collation-has-no-actual-version-but-a-version-was-recorded.md)
