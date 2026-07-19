---
message: "could not obtain lock on relation \"%s\""
slug: could-not-obtain-lock-on-relation-da8ac5
passthrough: false
api: [ereport]
level: [ERROR]
level_runtime_chosen: true
sqlstate:
  - symbol: ERRCODE_LOCK_NOT_AVAILABLE
    code: "55P03"
call_sites:
  - "postgres/src/backend/catalog/namespace.c:604"
  - "postgres/src/backend/commands/lockcmds.c:153"
  - "postgres/src/backend/commands/lockcmds.c:243"
reproduced: false
---

# `could not obtain lock on relation "%s"`

## What it means

Code that needed a lock on a relation by name could not acquire it in a non-blocking context. The placeholder names the relation. It surfaces from paths that take relation locks conditionally (for example name lookup that must not wait), where the lock was unavailable at that moment.

## When it happens

The relation was locked by another transaction (concurrent DDL or a long-running operation) at the instant a non-waiting lock attempt was made, or the object was being dropped concurrently.

## How to fix

Retry the operation — the conflicting lock is usually transient. If it recurs, find the blocking session (`pg_locks` joined with `pg_stat_activity`) and let it finish or end it. Avoid running conflicting DDL against the same relation concurrently.

## Example

*Illustrative* — a relation lock unavailable at lookup time.

```text
ERROR:  could not obtain lock on relation "t"
```

## Related

- [tuple concurrently updated](./tuple-concurrently-updated.md)
- [cannot PREPARE while holding both session-level and transaction-level locks on](./cannot-prepare-while-holding-both-session-level-and-transaction-level-locks-on.md)
