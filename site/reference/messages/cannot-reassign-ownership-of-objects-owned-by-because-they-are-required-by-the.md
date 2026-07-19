---
message: "cannot reassign ownership of objects owned by %s because they are required by the database system"
slug: cannot-reassign-ownership-of-objects-owned-by-because-they-are-required-by-the
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DEPENDENT_OBJECTS_STILL_EXIST
    code: "2BP01"
call_sites:
  - "postgres/src/backend/catalog/pg_shdepend.c:1558"
reproduced: false
---

# `cannot reassign ownership of objects owned by %s because they are required by the database system`

## What it means

A `REASSIGN OWNED` was blocked because some objects owned by the role are required by the database system. System-required objects — such as pinned catalog entries — have no user owner to reassign to. The placeholder is the role name.

## When it happens

It occurs when `REASSIGN OWNED BY role` includes objects the system depends on, which cannot change ownership.

## How to fix

Reassign the user-owned objects and leave the system-required ones as they are. In practice the role can still be dropped after reassigning its ordinary objects, since system-pinned objects are not truly owned by the role.

## Example

*Illustrative* — reassigning system-required objects.

```text
ERROR:  cannot reassign ownership of objects owned by role_x because they are required by the database system
```

## Related

- [cannot remove dependency on because it is a system object](./cannot-remove-dependency-on-because-it-is-a-system-object.md)
- [cannot rewrite system relation](./cannot-rewrite-system-relation.md)
