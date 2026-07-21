---
message: "aclinsert is no longer supported"
slug: aclinsert-is-no-longer-supported
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/adt/acl.c:1625"
reproduced: false
---

# `aclinsert is no longer supported`

## What it means

The obsolete `aclinsert` function was called. It was removed because direct manipulation of ACL arrays is no longer the supported way to change privileges.

## When it happens

It occurs when old code or a migration calls `aclinsert()` directly instead of using `GRANT`.

## How to fix

Use `GRANT` to add privileges rather than manipulating ACL arrays with `aclinsert`. Update any legacy scripts or extensions that still call the removed function to the standard privilege commands.

## Example

*Illustrative* — calling the removed aclinsert function.

```sql
SELECT aclinsert(relacl, ...) FROM pg_class;  -- ERROR:  aclinsert is no longer supported
```

## Related

- [aclremove is no longer supported](./aclremove-is-no-longer-supported.md)
- [ACL array contains wrong data type](./acl-array-contains-wrong-data-type.md)
