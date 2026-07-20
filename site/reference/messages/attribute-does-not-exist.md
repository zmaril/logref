---
message: "attribute \"%s\" does not exist"
slug: attribute-does-not-exist
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/execUtils.c:1127"
reproduced: false
---

# `attribute "%s" does not exist`

## What it means

Code that looks up a column by name against a relation's tuple descriptor found no attribute with that name. The placeholder is the column name that was requested.

## When it happens

It is raised from internal attribute-resolution paths and from some extensions that map names to columns. It generally reflects a stale descriptor or a name that does not belong to the relation being addressed.

## How to fix

Confirm the column name against the current definition of the relation with `\d relation`. If the name is correct and the error still fires, a cached plan or descriptor may be stale — reconnect or `DISCARD ALL` — and rule out an extension passing an unexpected column name.

## Example

*Illustrative* — a lookup for a column the relation lacks.

```text
ERROR:  attribute "widget" does not exist
```

## Related

- [attribute of type has been dropped](./attribute-of-type-has-been-dropped.md)
- [atttypid is invalid for non-dropped column](./atttypid-is-invalid-for-non-dropped-column-in.md)
