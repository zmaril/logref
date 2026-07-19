---
message: "could not find tuple for role membership %u"
slug: could-not-find-tuple-for-role-membership
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:3758"
reproduced: false
---

# `could not find tuple for role membership %u`

## What it means

Object-address code looked up a role-membership row by its identifier and did not find it. The row records that one role belongs to another; without it the membership cannot be described.

## When it happens

It fires while resolving a membership reference, when the grant was revoked concurrently or the catalog is inconsistent.

## How to fix

This is an internal guard. It usually means a membership was revoked while another operation still referred to it. Avoid concurrent role-membership changes during the operation. On stable definitions, capture the identifier and report a reproducible case.

## Example

*Illustrative* — a missing role-membership row.

```text
ERROR:  could not find tuple for role membership 16712
```

## Related

- [could not find tuple for pg_auth_members entry](./could-not-find-tuple-for-pg-auth-members-entry.md)
- [could not find tuple for role](./could-not-find-tuple-for-role.md)
