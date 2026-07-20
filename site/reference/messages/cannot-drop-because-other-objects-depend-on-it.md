---
message: "cannot drop %s because other objects depend on it"
slug: cannot-drop-because-other-objects-depend-on-it
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DEPENDENT_OBJECTS_STILL_EXIST
    code: "2BP01"
call_sites:
  - "postgres/src/backend/catalog/dependency.c:1214"
reproduced: false
---

# `cannot drop %s because other objects depend on it`

## What it means

A `DROP` was refused because one or more other objects depend on the target. The message detail lists the dependents. Removing the target without them would leave those objects broken. The placeholder is the target object.

## When it happens

It occurs when dropping an object that other objects reference, and `CASCADE` was not specified.

## How to fix

Drop the dependents first, or add `CASCADE` to remove the target and all dependents together. Read the accompanying detail to see exactly what depends on the object before cascading.

## Example

*Illustrative* — a blocked drop with dependents.

```text
ERROR:  cannot drop table t because other objects depend on it
```

## Related

- [cannot drop because depends on it](./cannot-drop-because-depends-on-it.md)
- [cannot drop desired object(s) because other objects depend on them](./cannot-drop-desired-object-s-because-other-objects-depend-on-them.md)
