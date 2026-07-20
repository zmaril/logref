---
message: "cannot read pg_class without having selected a database"
slug: cannot-read-pg-class-without-having-selected-a-database
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/utils/cache/relcache.c:359"
reproduced: false
---

# `cannot read pg_class without having selected a database`

## What it means

An internal guard fired: relation-cache code tried to read `pg_class` before the backend had selected a database. Catalog access needs a database context, and this path ran too early in startup. It marks a coding issue in startup sequencing.

## When it happens

It is reached only if backend initialization reaches catalog access before database selection. It reflects an internal ordering issue rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the startup circumstances and any custom background-worker or extension code that runs early, then report it.

## Example

*Illustrative* — catalog read before database selection.

```text
FATAL:  cannot read pg_class without having selected a database
```

## Related

- [cannot register background worker after shmem init](./cannot-register-background-worker-after-shmem-init.md)
- [cannot request shared memory at this time](./cannot-request-shared-memory-at-this-time.md)
