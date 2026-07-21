---
message: "cannot change tablespace of mapped relation \"%s\""
slug: cannot-change-tablespace-of-mapped-relation
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/repack.c:1628"
reproduced: false
---

# `cannot change tablespace of mapped relation "%s"`

## What it means

An internal guard: a command tried to move a mapped relation — a core catalog tracked by the relation-mapping mechanism — to a different tablespace. Mapped catalogs have a fixed location that cannot be relocated this way. The placeholder is the relation name.

## When it happens

It is reached when an operation would change the tablespace of a nailed system catalog. User tables never hit this guard.

## How to fix

There is no user-level fix; mapped catalogs cannot change tablespace. If it appears from ordinary DDL, capture the command and report it, since user statements should not reach a mapped relation here.

## Example

*Illustrative* — moving a mapped catalog's tablespace.

```text
ERROR:  cannot change tablespace of mapped relation "pg_class"
```

## Related

- [cannot change access method of mapped relation](./cannot-change-access-method-of-mapped-relation.md)
- [cannot change persistence of mapped relation](./cannot-change-persistence-of-mapped-relation.md)
