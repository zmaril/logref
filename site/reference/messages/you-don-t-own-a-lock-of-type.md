---
message: "you don't own a lock of type %s"
slug: you-don-t-own-a-lock-of-type
passthrough: false
api: [elog]
level: [WARNING]
call_sites:
  - "postgres/src/backend/storage/lmgr/lock.c:733"
  - "postgres/src/backend/storage/lmgr/lock.c:763"
  - "postgres/src/backend/storage/lmgr/lock.c:2150"
  - "postgres/src/backend/storage/lmgr/lock.c:2189"
  - "postgres/src/backend/storage/lmgr/lock.c:2285"
  - "postgres/src/backend/storage/lmgr/lock.c:3344"
reproduced: true
---

# `you don't own a lock of type %s`

## What it means

Internal warning. The lock manager was asked to release a lock of a given mode that the current transaction does not actually hold. The placeholder is the lock mode. It is a self-check in `LockRelease`, warning that a release did not match any held lock.

## When it happens

It should not occur through normal locking. Reaching it usually indicates a bug in code that acquires and releases locks in an unbalanced way — often an extension — rather than anything in your SQL.

## Is this a problem?

Usually harmless to the statement in progress but worth noting: it signals unbalanced lock handling somewhere. If it correlates with a specific extension, suspect that extension. If reproducible, capture the workload and report it.

## Example

*Reproduced* — captured from `reproducers/scenarios/22_system_admin_funcs.sql`.

```sql
SELECT pg_advisory_unlock(999);
```

Produces:

```text
WARNING:  you don't own a lock of type ExclusiveLock
```

## Related

- [could not obtain lock on row in relation](./could-not-obtain-lock-on-row-in-relation.md)
- [attempted to lock invisible tuple](./attempted-to-lock-invisible-tuple.md)
