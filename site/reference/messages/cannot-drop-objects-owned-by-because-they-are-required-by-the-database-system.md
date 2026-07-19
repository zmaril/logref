---
message: "cannot drop objects owned by %s because they are required by the database system"
slug: cannot-drop-objects-owned-by-because-they-are-required-by-the-database-system
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DEPENDENT_OBJECTS_STILL_EXIST
    code: "2BP01"
call_sites:
  - "postgres/src/backend/catalog/pg_shdepend.c:1377"
reproduced: false
---

# `cannot drop objects owned by %s because they are required by the database system`

## What it means

A `DROP OWNED BY` or a role drop tried to remove objects owned by a role that the database system itself needs — for example objects belonging to a bootstrap or system role. Such objects cannot be dropped. The placeholder is the role.

## When it happens

It occurs when dropping the objects of a role that owns system-required objects, such as an initial superuser or a role tied to built-in functionality.

## How to fix

Do not attempt to drop system-required objects. Reassign or remove only the user objects of ordinary roles; leave roles and objects the system depends on in place.

## Example

*Illustrative* — dropping system-required objects.

```text
ERROR:  cannot drop objects owned by role "r" because they are required by the database system
```

## Related

- [cannot drop system column](./cannot-drop-system-column.md)
- [cannot drop because other objects depend on it](./cannot-drop-because-other-objects-depend-on-it.md)
