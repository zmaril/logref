---
message: "cannot remove dependency on %s because it is a system object"
slug: cannot-remove-dependency-on-because-it-is-a-system-object
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/catalog/pg_depend.c:665"
reproduced: false
---

# `cannot remove dependency on %s because it is a system object`

## What it means

An operation tried to drop a dependency that points at a system object. Dependencies on built-in, system-required objects are fixed and cannot be removed. The placeholder describes the object.

## When it happens

It occurs when a `DROP` or an extension-management operation would sever a dependency on a system object, such as a pinned catalog entry.

## How to fix

There is no user-level action to remove a system-object dependency. Restructure the operation so it does not attempt to drop that dependency; if it appears while managing an extension, review the extension's dependency declarations.

## Example

*Illustrative* — removing a dependency on a system object.

```text
ERROR:  cannot remove dependency on schema pg_catalog because it is a system object
```

## Related

- [cannot reassign ownership of objects owned by because they are required by the database system](./cannot-reassign-ownership-of-objects-owned-by-because-they-are-required-by-the.md)
- [cannot rewrite system relation](./cannot-rewrite-system-relation.md)
