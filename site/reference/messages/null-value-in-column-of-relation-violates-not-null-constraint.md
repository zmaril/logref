---
message: "null value in column \"%s\" of relation \"%s\" violates not-null constraint"
slug: null-value-in-column-of-relation-violates-not-null-constraint
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NOT_NULL_VIOLATION
    code: "23502"
call_sites:
  - "postgres/src/backend/executor/execMain.c:2275"
reproduced: false
---

# `null value in column "%s" of relation "%s" violates not-null constraint`

**Severity:** ERROR · SQLSTATE `23502` (ERRCODE_NOT_NULL_VIOLATION)

## What it means

A row left a `NOT NULL` column empty. The placeholders name the column and the table. A `NOT NULL` constraint says every row must carry a value there, and this write did not provide one.

## When it happens

An `INSERT` that omits the column and has no usable default, an `UPDATE` that sets it to `NULL`, or an `ALTER TABLE t ALTER COLUMN c SET NOT NULL` run against a table that already holds null rows. It also appears when a default was expected but the column has none, or when a trigger clears the value.

## How to fix

Provide a value for the named column, or give the column a `DEFAULT` so omitted inserts fill it in. If you are adding the constraint to existing data, first `UPDATE` the null rows to a sensible value (or delete them), then re-run `SET NOT NULL`. If nulls are genuinely valid for this column, the constraint itself is wrong — drop it deliberately rather than working around it per-insert.

## Example

*Illustrative* — inserting without a required column (`04_constraints.sql`).

```sql
CREATE TABLE t (id int, label text NOT NULL);
INSERT INTO t (id) VALUES (1);
```

Produces:

```text
ERROR:  null value in column "label" of relation "t" violates not-null constraint
```

## Source

Emitted from [`postgres/src/backend/executor/execMain.c:2275`](https://github.com/postgres/postgres/blob/master/src/backend/executor/execMain.c#L2275).

## SQLSTATE

- `23502` — **ERRCODE_NOT_NULL_VIOLATION**. Class 23 (Integrity Constraint Violation).

## Related

- [duplicate key value violates unique constraint](./duplicate-key-value-violates-unique-constraint.md)
