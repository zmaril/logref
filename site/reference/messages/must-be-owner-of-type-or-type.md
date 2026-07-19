---
message: "must be owner of type %s or type %s"
slug: must-be-owner-of-type-or-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:2595"
  - "postgres/src/backend/commands/functioncmds.c:1579"
reproduced: false
---

# `must be owner of type %s or type %s`

## What it means

An operation involving two types requires ownership of at least one of them, and the current role owns neither. The placeholders name the two types.

## When it happens

It arises from commands that relate two types — for example creating a cast or operating on a type pair — when the role lacks ownership of both types involved.

## How to fix

Run the command as the owner of one of the named types, or as a superuser. If appropriate, transfer ownership with `ALTER TYPE name OWNER TO role`, or have a privileged role perform the operation.

## Example

*Illustrative* — creating a cast without owning either type.

```sql
CREATE CAST (typea AS typeb) WITH FUNCTION f;  -- must own one of the types
```

## Related

- [must be owner of large object](./must-be-owner-of-large-object.md)
- [only superuser can define a leakproof function](./only-superuser-can-define-a-leakproof-function.md)
