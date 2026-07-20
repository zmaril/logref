---
message: "dependent privileges exist"
slug: dependent-privileges-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DEPENDENT_OBJECTS_STILL_EXIST
    code: "2BP01"
call_sites:
  - "postgres/src/backend/commands/user.c:2504"
  - "postgres/src/backend/utils/adt/acl.c:1370"
reproduced: false
---

# `dependent privileges exist`

## What it means

A `REVOKE` could not proceed because privileges granted onward from the ones being revoked still exist. Revoking a grant that others depend on requires cascading.

## When it happens

Revoking a privilege that the grantee has re-granted to other roles (a `WITH GRANT OPTION` chain), without `CASCADE`.

## How to fix

Add `CASCADE` to revoke the dependent grants along with the target, or revoke the downstream grants first. `RESTRICT` (the default) refuses while dependents remain.

## Example

*Illustrative* — revoking a grant with dependents.

```text
ERROR:  dependent privileges exist
HINT:  Use CASCADE to revoke them too.
```

## Related

- [current user cannot be dropped](./current-user-cannot-be-dropped.md)
- [grantable rights not supported for event triggers](./grantable-rights-not-supported-for-event-triggers.md)
