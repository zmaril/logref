---
message: "cannot drop %s because %s depends on it"
slug: cannot-drop-because-depends-on-it
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DEPENDENT_OBJECTS_STILL_EXIST
    code: "2BP01"
call_sites:
  - "postgres/src/backend/catalog/dependency.c:908"
reproduced: false
---

# `cannot drop %s because %s depends on it`

## What it means

A `DROP` was refused because another named object depends on the target. Dropping it would leave that dependent broken, so Postgres blocks the drop unless you also remove or detach the dependent. The placeholders are the target object and the dependent object.

## When it happens

It occurs when dropping an object — a table, type, function, or similar — that another object references directly.

## How to fix

Drop or alter the dependent object first, or use `DROP ... CASCADE` to remove the target and everything that depends on it. Review the named dependent before choosing cascade so you do not remove more than intended.

## Example

*Illustrative* — a blocked drop with one dependent.

```text
ERROR:  cannot drop table t because view v depends on it
```

## Related

- [cannot drop because other objects depend on it](./cannot-drop-because-other-objects-depend-on-it.md)
- [cannot drop desired object(s) because other objects depend on them](./cannot-drop-desired-object-s-because-other-objects-depend-on-them.md)
