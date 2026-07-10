---
message: "relation \"%s\" already exists"
slug: relation-already-exists
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_TABLE
    code: "42P07"
call_sites:
  - "postgres/src/backend/catalog/heap.c:1195"
  - "postgres/src/backend/catalog/index.c:904"
  - "postgres/src/backend/commands/createas.c:406"
  - "postgres/src/backend/commands/tablecmds.c:4396"
  - "postgres/src/backend/commands/tablecmds.c:23244"
  - "postgres/src/backend/commands/tablecmds.c:23842"
  - "postgres/src/backend/commands/tablecmds.c:24272"
reproduced: true
---

# `relation "%s" already exists`

**Severity:** ERROR · SQLSTATE `42P07` (ERRCODE_DUPLICATE_TABLE)

## What it means

A `CREATE` tried to make a relation (table, index, view, sequence, materialized view) under a name already taken in that schema. Names must be unique per schema across all relation kinds, so a table and an index cannot share a name.

## When it happens

Re-running a `CREATE TABLE`/`CREATE INDEX`/`CREATE VIEW` that already ran, a migration applied twice, or two objects colliding on one name. It also surfaces when an auto-generated name (a serial's sequence, an index) clashes with an object you created by hand.

## How to fix

If re-creation is intentional and idempotent, add `IF NOT EXISTS` (as in `CREATE TABLE IF NOT EXISTS name`) or `CREATE OR REPLACE` where supported (views, functions). If the existing object is stale, drop it first. If two different objects genuinely need to coexist, rename one. For migrations, make them idempotent or track which have already been applied so they do not re-run.

## Example

*Reproduced* — The DDL-duplicate reproducer scenario re-creates existing objects (`06_ddl_duplicate.sql`).

```sql
CREATE INDEX child_amount_idx ON repro.child (amount);
CREATE INDEX child_amount_idx ON repro.child (amount);
```

Produces:

```text
ERROR:  relation "child_amount_idx" already exists
```

## Source

This message text is emitted from 7 call sites:

- [`postgres/src/backend/catalog/heap.c:1195`](https://github.com/postgres/postgres/blob/master/src/backend/catalog/heap.c#L1195) — ERROR
- [`postgres/src/backend/catalog/index.c:904`](https://github.com/postgres/postgres/blob/master/src/backend/catalog/index.c#L904) — ERROR
- [`postgres/src/backend/commands/createas.c:406`](https://github.com/postgres/postgres/blob/master/src/backend/commands/createas.c#L406) — ERROR
- [`postgres/src/backend/commands/tablecmds.c:4396`](https://github.com/postgres/postgres/blob/master/src/backend/commands/tablecmds.c#L4396) — ERROR
- [`postgres/src/backend/commands/tablecmds.c:23244`](https://github.com/postgres/postgres/blob/master/src/backend/commands/tablecmds.c#L23244) — ERROR
- [`postgres/src/backend/commands/tablecmds.c:23842`](https://github.com/postgres/postgres/blob/master/src/backend/commands/tablecmds.c#L23842) — ERROR
- [`postgres/src/backend/commands/tablecmds.c:24272`](https://github.com/postgres/postgres/blob/master/src/backend/commands/tablecmds.c#L24272) — ERROR

## SQLSTATE

- `42P07` — **ERRCODE_DUPLICATE_TABLE**. Class 42 (Syntax Error or Access Rule Violation).

## Related

- [relation "%s" does not exist](./relation-does-not-exist-d06d8d.md)
- [function already exists with same argument types](./function-already-exists-with-same-argument-types.md)
- [duplicate key value violates unique constraint](./duplicate-key-value-violates-unique-constraint.md)
