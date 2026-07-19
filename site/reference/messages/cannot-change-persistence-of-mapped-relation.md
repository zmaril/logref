---
message: "cannot change persistence of mapped relation \"%s\""
slug: cannot-change-persistence-of-mapped-relation
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/repack.c:1631"
reproduced: false
---

# `cannot change persistence of mapped relation "%s"`

## What it means

An internal guard: a command tried to change the persistence (logged or unlogged) of a mapped relation — a core catalog tracked by the relation-mapping mechanism. Mapped catalogs have a fixed persistence that cannot be switched. The placeholder is the relation name.

## When it happens

It is reached when an operation would change the persistence of a nailed system catalog. User tables never reach this guard.

## How to fix

There is no user-level fix; mapped catalogs cannot change persistence. If it appears from ordinary DDL, capture the command and report it, since user statements should not reach a mapped relation here.

## Example

*Illustrative* — persistence change on a mapped catalog.

```text
ERROR:  cannot change persistence of mapped relation "pg_class"
```

## Related

- [cannot change access method of mapped relation](./cannot-change-access-method-of-mapped-relation.md)
- [cannot change tablespace of mapped relation](./cannot-change-tablespace-of-mapped-relation.md)
