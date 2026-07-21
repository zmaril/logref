---
message: "savepoint \"%s\" does not exist within current savepoint level"
slug: savepoint-does-not-exist-within-current-savepoint-level
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_S_E_INVALID_SPECIFICATION
    code: "3B001"
call_sites:
  - "postgres/src/backend/access/transam/xact.c:4593"
  - "postgres/src/backend/access/transam/xact.c:4702"
reproduced: false
---

# `savepoint "%s" does not exist within current savepoint level`

## What it means

A `ROLLBACK TO SAVEPOINT` or `RELEASE SAVEPOINT` named a savepoint that is not defined at the current savepoint level. The placeholder is the savepoint name. Savepoints are scoped, and one from an outer or already-released level is not visible here.

## When it happens

It arises when rolling back to or releasing a savepoint that was never created, was already released, or belongs to a different nesting level — for example inside a PL/pgSQL block whose savepoint scope differs.

## How to fix

Create the savepoint with `SAVEPOINT name` before referencing it, and reference it within the same level. Check that an earlier `RELEASE`/`ROLLBACK TO` did not already consume it, and that names are spelled consistently.

## Example

*Illustrative* — rolling back to a savepoint that is not in scope.

```text
ERROR:  savepoint "sp1" does not exist within current savepoint level
```

## Related

- [portal "%s" does not exist](./portal-does-not-exist.md)
- [standby promotion is ongoing](./standby-promotion-is-ongoing.md)
