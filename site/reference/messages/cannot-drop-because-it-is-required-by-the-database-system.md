---
message: "cannot drop %s because it is required by the database system"
slug: cannot-drop-because-it-is-required-by-the-database-system
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DEPENDENT_OBJECTS_STILL_EXIST
    code: "2BP01"
call_sites:
  - "postgres/src/backend/catalog/dependency.c:551"
  - "postgres/src/backend/catalog/pg_shdepend.c:701"
reproduced: false
---

# `cannot drop %s because it is required by the database system`

## What it means

A `DROP` targeted an object the server itself depends on — a built-in (pinned) object recorded as required in `pg_depend`/`pg_shdepend`. The placeholder describes the object. These system objects cannot be dropped.

## When it happens

Attempting to drop a built-in role, type, function, or other pinned system object — sometimes reached indirectly through `DROP OWNED` or a cascade that touches a system object.

## How to fix

Do not drop built-in objects; they are part of the running system. If a cascade or `DROP OWNED` reached one, narrow the operation to the user objects you actually mean to remove. There is no supported way to delete required system objects.

## Example

*Illustrative* — dropping a pinned system object.

```sql
DROP TYPE integer;
-- ERROR:  cannot drop type integer because it is required by the database system
```

## Related

- [cannot drop because requires it](./cannot-drop-because-requires-it.md)
- [constant of the type cannot be used here](./constant-of-the-type-cannot-be-used-here.md)
