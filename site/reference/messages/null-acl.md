---
message: "null ACL"
slug: null-acl
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/acl.c:1433"
  - "postgres/src/backend/utils/adt/acl.c:1521"
reproduced: false
---

# `null ACL`

## What it means

Internal error. Privilege-handling code received a null access control list (ACL) where a valid ACL array was required. It is a consistency guard over `acl` values in the catalogs.

## When it happens

It fires when reading or manipulating an object's permissions and the stored ACL is unexpectedly null. Normal `GRANT`/`REVOKE` handling does not surface it; it points to catalog inconsistency or an internal bug.

## How to fix

This is a can't-happen guard. If a specific object triggers it, review its privileges; re-establishing them with `GRANT`/`REVOKE` rewrites the ACL. Capture the object and operation and report a reproducible case.

## Example

*Illustrative* — a null ACL where one was required.

```text
ERROR:  null ACL
```

## Related

- [null conbin for relation](./null-conbin-for-relation.md)
- [option cannot be granted back to your own grantor](./option-cannot-be-granted-back-to-your-own-grantor.md)
