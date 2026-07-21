---
message: "cannot change access method of mapped relation \"%s\""
slug: cannot-change-access-method-of-mapped-relation
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/repack.c:1634"
reproduced: false
---

# `cannot change access method of mapped relation "%s"`

## What it means

An internal guard: a command tried to change the table access method of a mapped relation — a core catalog whose physical location is tracked outside the normal catalogs by the relation-mapping mechanism. Mapped relations have a fixed on-disk representation that cannot be swapped. The placeholder is the relation name.

## When it happens

It is reached when an operation such as a rewrite would change the access method of a nailed system catalog. Ordinary user tables never hit this guard.

## How to fix

There is no user-level fix; mapped catalogs cannot change access method. If it appears from normal DDL, capture the exact command and report it, since user statements should not reach a mapped relation here.

## Example

*Illustrative* — access-method change on a mapped catalog.

```text
ERROR:  cannot change access method of mapped relation "pg_class"
```

## Related

- [cannot change persistence of mapped relation](./cannot-change-persistence-of-mapped-relation.md)
- [cannot change tablespace of mapped relation](./cannot-change-tablespace-of-mapped-relation.md)
