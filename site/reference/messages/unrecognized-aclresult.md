---
message: "unrecognized AclResult: %d"
slug: unrecognized-aclresult
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/aclchk.c:2960"
  - "postgres/src/backend/catalog/aclchk.c:2986"
reproduced: false
---

# `unrecognized AclResult: %d`

## What it means

Internal error. Privilege-checking code received an ACL-result code that is neither the ok, no-privilege, nor no-such-object case it expects.

## When it happens

It fires where the outcome of an access-control check is switched on and the value is outside the known set. Normal permission checks do not produce it.

## How to fix

This is an internal guard. If routine access checks reach it, capture the operation and the object involved and report it as a reproducible bug.

## Example

*Illustrative* — an unrecognized ACL result.

```text
ERROR:  unrecognized AclResult: 4
```

## Related

- [unexpected role type %d](./unexpected-role-type.md)
- [unrecognized policy command](./unrecognized-policy-command.md)
