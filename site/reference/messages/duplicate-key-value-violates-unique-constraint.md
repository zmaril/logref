---
message: "duplicate key value violates unique constraint \"%s\""
slug: duplicate-key-value-violates-unique-constraint
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNIQUE_VIOLATION
    code: "23505"
call_sites:
  - "postgres/src/backend/access/nbtree/nbtinsert.c:669"
reproduced: false
---

# `duplicate key value violates unique constraint "%s"`

## What it means

A row would have created a second copy of a value that a unique constraint or unique index requires to be distinct. The placeholder names the constraint; the error detail (a separate line) prints the conflicting key value. This is the single most common write error in production Postgres.

## When it happens

An `INSERT` or an `UPDATE` that sets a column already present in another row, across any `UNIQUE` constraint, `PRIMARY KEY`, or unique index. It also fires on concurrent inserts racing for the same key, and when a retried request re-sends a row that already landed.

## How to fix

Decide what a duplicate should mean. To make inserts idempotent, use `INSERT INTO t VALUES (v) ON CONFLICT (col) DO NOTHING`, or `ON CONFLICT (col) DO UPDATE SET col = excluded.col` for an upsert. To find the existing row, look at the DETAIL line — it prints the conflicting value — and query for it. If the duplicate is unexpected, the application is probably generating colliding keys or double-submitting; fix the key generation or add idempotency. Never drop the constraint to silence the error — it is protecting real invariants.

## Example

*Illustrative* — inserting a row whose unique column already exists (`04_constraints.sql`).

```sql
CREATE TABLE t (email text UNIQUE);
INSERT INTO t VALUES ('a@example.com');
INSERT INTO t VALUES ('a@example.com');
```

Produces:

```text
ERROR:  duplicate key value violates unique constraint "t_email_key"
DETAIL:  Key (email)=(a@example.com) already exists.
```

## Related

- [null value violates not-null constraint](./null-value-in-column-of-relation-violates-not-null-constraint.md)
- [relation "%s" already exists](./relation-already-exists.md)
