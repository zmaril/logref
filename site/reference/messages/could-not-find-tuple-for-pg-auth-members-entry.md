---
message: "could not find tuple for pg_auth_members entry %u"
slug: could-not-find-tuple-for-pg-auth-members-entry
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:5856"
reproduced: false
---

# `could not find tuple for pg_auth_members entry %u`

## What it means

Object-address code looked up a `pg_auth_members` row — a single role-membership grant — by its identifier and did not find it. That row records that one role is a member of another.

## When it happens

It fires while turning a membership grant into a readable object reference (for dependency or error reporting), when the membership row is gone — usually revoked concurrently, or an inconsistent catalog.

## How to fix

This is an internal guard. It generally means a role membership was revoked while something still referred to it. Avoid changing role memberships concurrently with the operation. On stable definitions, capture the entry OID and report a reproducible case.

## Example

*Illustrative* — a missing membership row.

```text
ERROR:  could not find tuple for pg_auth_members entry 16711
```

## Related

- [could not find tuple for role membership](./could-not-find-tuple-for-role-membership.md)
- [could not find tuple for role](./could-not-find-tuple-for-role.md)
