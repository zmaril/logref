---
message: "aclremove is no longer supported"
slug: aclremove-is-no-longer-supported
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/adt/acl.c:1635"
reproduced: false
---

# `aclremove is no longer supported`

## What it means

The obsolete `aclremove` function was called. It was removed because direct manipulation of ACL arrays is no longer the supported way to change privileges.

## When it happens

It occurs when old code or a migration calls `aclremove()` directly instead of using `REVOKE`.

## How to fix

Use `REVOKE` to remove privileges rather than manipulating ACL arrays with `aclremove`. Update legacy scripts or extensions that still call the removed function to the standard privilege commands.

## Example

*Illustrative* — calling the removed aclremove function.

```sql
SELECT aclremove(relacl, ...) FROM pg_class;  -- ERROR:  aclremove is no longer supported
```

## Related

- [aclinsert is no longer supported](./aclinsert-is-no-longer-supported.md)
- [ACL arrays must not contain null values](./acl-arrays-must-not-contain-null-values.md)
