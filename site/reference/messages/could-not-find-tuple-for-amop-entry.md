---
message: "could not find tuple for amop entry %u"
slug: could-not-find-tuple-for-amop-entry
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:3357"
  - "postgres/src/backend/catalog/objectaddress.c:5501"
reproduced: false
---

# `could not find tuple for amop entry %u`

## What it means

Internal error. Object-address code looked up a `pg_amop` (access-method operator) catalog row by OID and did not find it. The placeholder is the OID. The operator-family/operator-class machinery expected the row to exist.

## When it happens

It should not occur through ordinary SQL. Reaching it points to a catalog inconsistency in the access-method operator entries — often surfacing during dependency or object-address processing for an operator class.

## How to fix

Treat it as a catalog inconsistency. Capture the command and the operator class or family involved and report it. If a specific operator class reproduces it, inspect `pg_amop` for the OID; a missing row suggests catalog corruption worth restoring from backup.

## Example

*Illustrative* — a missing pg_amop row.

```text
ERROR:  could not find tuple for amop entry 12345
```

## Related

- [could not find tuple for](./could-not-find-tuple-for.md)
- [cache lookup failed for operator family](./cache-lookup-failed-for-operator-family.md)
