---
message: "Did not find any relation with OID %s."
slug: did-not-find-any-relation-with-oid
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/describe.c:1641"
reproduced: false
---

# `Did not find any relation with OID %s.`

## What it means

A psql describe command was asked to describe a relation by OID and no relation has that OID. The placeholder is the OID. This is psql reporting an empty result, not a server error.

## When it happens

It fires when psql resolves a relation by OID (for example after `\d` on an OID) and the OID does not correspond to any relation, often because the object was dropped.

## How to fix

Confirm the OID is current — OIDs change when objects are recreated. Look the object up by name instead, or query `pg_class` for the current OID.

## Example

*Illustrative* — an OID that no longer exists.

```text
-- Did not find any relation with OID 999999.
```

## Related

- [Did not find any relation named](./did-not-find-any-relation-named.md)
- [Did not find any relations](./did-not-find-any-relations-fc25da.md)
