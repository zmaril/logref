---
message: "unexpected role type %d"
slug: unexpected-role-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/acl.c:5670"
  - "postgres/src/backend/utils/adt/acl.c:5717"
reproduced: false
---

# `unexpected role type %d`

## What it means

Internal error. Role-handling code met a role classification value outside the set it recognizes while processing a grant, membership, or default-ACL operation.

## When it happens

It fires where a role kind is switched on and the value does not match a known case. Normal role management does not reach it.

## How to fix

This is an internal guard. If routine role DDL triggers it, capture the statement and the roles involved and report it as a reproducible bug.

## Example

*Illustrative* — an unrecognized role type.

```text
ERROR:  unexpected role type 3
```

## Related

- [unrecognized AclResult: %d](./unrecognized-aclresult.md)
- [you already exist](./you-already-exist.md)
