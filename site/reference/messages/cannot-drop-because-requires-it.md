---
message: "cannot drop %s because %s requires it"
slug: cannot-drop-because-requires-it
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DEPENDENT_OBJECTS_STILL_EXIST
    code: "2BP01"
call_sites:
  - "postgres/src/backend/catalog/dependency.c:843"
  - "postgres/src/backend/catalog/dependency.c:1080"
reproduced: false
---

# `cannot drop %s because %s requires it`

## What it means

A `DROP` was refused because another object depends on the target and requires it to exist. The placeholders describe the object being dropped and the dependent object. Removing it without addressing the dependency would leave the dependent broken.

## When it happens

Dropping a table, type, function, or other object that a view, constraint, default, or another object still references, without `CASCADE`.

## How to fix

Drop or alter the dependent object first, or add `CASCADE` to remove both together once you have confirmed that is safe. Use the error `DETAIL` (or `pg_depend`) to see every dependent before deciding. Prefer explicit drops over a broad `CASCADE`.

## Example

*Illustrative* — a type still used by a column.

```sql
DROP TYPE mood;
-- ERROR:  cannot drop type mood because other objects depend on it
```

## Related

- [cannot drop because it is required by the database system](./cannot-drop-because-it-is-required-by-the-database-system.md)
- [cannot drop columns from view](./cannot-drop-columns-from-view.md)
