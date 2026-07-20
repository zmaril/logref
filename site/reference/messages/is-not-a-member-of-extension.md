---
message: "%s is not a member of extension \"%s\""
slug: is-not-a-member-of-extension
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/catalog/pg_depend.c:241"
  - "postgres/src/backend/catalog/pg_depend.c:292"
  - "postgres/src/backend/commands/extension.c:3921"
reproduced: false
---

# `%s is not a member of extension "%s"`

## What it means

A command asked to detach or reassign an object's membership in an extension, but the object is not part of that extension. Extension membership ties objects to the extension that owns them, and this object was not owned by the named extension.

## When it happens

Running `ALTER EXTENSION ... DROP` or a dependency operation naming an object that the extension does not own, or naming the wrong extension for an object that belongs to a different one.

## How to fix

Confirm which extension actually owns the object. Query `pg_depend`, or inspect the extension with `\dx+ extname` in psql, and name the correct extension. If the object should belong to the extension, add it with `ALTER EXTENSION ... ADD` first.

## Example

*Illustrative* — dropping membership the object does not have.

```sql
ALTER EXTENSION hstore DROP FUNCTION unrelated_fn();  -- not a member of hstore
```

## Related

- [is not a member of extension being dropped](./is-not-a-member-of-extension.md)
- [cannot drop extension because it is being modified](./cannot-drop-extension-because-it-is-being-modified.md)
