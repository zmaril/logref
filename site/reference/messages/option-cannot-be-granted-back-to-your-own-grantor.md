---
message: "%s option cannot be granted back to your own grantor"
slug: option-cannot-be-granted-back-to-your-own-grantor
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_GRANT_OPERATION
    code: "0LP01"
call_sites:
  - "postgres/src/backend/commands/user.c:1798"
  - "postgres/src/backend/commands/user.c:1824"
reproduced: false
---

# `%s option cannot be granted back to your own grantor`

## What it means

A `GRANT` tried to give a privilege (or membership) back to the very role that granted it to you, forming a grant cycle. The placeholder names the option/privilege. Such a back-grant is not allowed.

## When it happens

It arises from `GRANT ... WITH GRANT OPTION` or `GRANT role` chains where role A granted to role B, and B then attempts to grant the same right back to A.

## How to fix

Do not grant a privilege back to the role you received it from. If the target role legitimately needs the privilege from another source, have a different grantor (such as the object owner or a superuser) grant it.

## Example

*Illustrative* — granting a privilege back to its grantor.

```sql
GRANT SELECT ON t TO grantor_role;  -- cannot grant back to your own grantor
```

## Related

- [must be owner of type or type](./must-be-owner-of-type-or-type.md)
- [null ACL](./null-acl.md)
