---
message: "role with OID %u does not exist"
slug: role-with-oid-does-not-exist
passthrough: false
api: [ereport, pg_fatal]
level: [ERROR, FATAL]
sqlstate:
  - symbol: ERRCODE_INVALID_AUTHORIZATION_SPECIFICATION
    code: "28000"
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/utils/adt/ddlutils.c:164"
  - "postgres/src/backend/utils/init/miscinit.c:760"
  - "postgres/src/bin/pg_dump/pg_dump.c:10673"
reproduced: false
---

# `role with OID %u does not exist`

## What it means

Code referenced a role by its object identifier, and no role with that identifier exists. The reference carries the numeric identifier directly, so this comes from an internal or catalog-level lookup rather than a name.

## When it happens

A role was dropped while another session or object still referenced its identifier — for example an ownership or privilege entry pointing at a now-removed role, or session initialization for a role removed concurrently. It can surface at FATAL during connection setup.

## How to fix

The referenced role was usually dropped; recreate it if the reference should still resolve, or reassign the dependent objects to an existing role. For connection-time failures, confirm the login role still exists. Persistent references to a missing role identifier suggest leftover ownership that should be reassigned with `REASSIGN OWNED` before dropping roles.

## Example

*Illustrative* — a reference to a dropped role's identifier.

```text
ERROR:  role with OID 16394 does not exist
```

## Related

- [permission denied to drop role](./permission-denied-to-drop-role.md)
- [relation with oid does not exist](./relation-with-oid-does-not-exist.md)
