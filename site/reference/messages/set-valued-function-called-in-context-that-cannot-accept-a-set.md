---
message: "set-valued function called in context that cannot accept a set"
slug: set-valued-function-called-in-context-that-cannot-accept-a-set
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/contrib/dblink/dblink.c:843"
  - "postgres/contrib/tablefunc/tablefunc.c:382"
  - "postgres/contrib/tablefunc/tablefunc.c:650"
  - "postgres/contrib/tablefunc/tablefunc.c:997"
  - "postgres/contrib/tablefunc/tablefunc.c:1076"
  - "postgres/src/backend/executor/execExpr.c:2747"
  - "postgres/src/backend/executor/execSRF.c:738"
  - "postgres/src/backend/executor/functions.c:1603"
  - "postgres/src/backend/utils/adt/jsonfuncs.c:4054"
  - "postgres/src/backend/utils/fmgr/funcapi.c:87"
  - "postgres/src/backend/utils/fmgr/funcapi.c:141"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:658"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:3712"
  - "postgres/src/pl/tcl/pltcl.c:841"
reproduced: false
---

# `set-valued function called in context that cannot accept a set`

## What it means

A set-returning function (SRF) was used where only a single value is allowed. The function can return multiple rows, but the surrounding expression expects a scalar, so Postgres cannot expand the set there.

## When it happens

Placing a set-returning function like `generate_series`, `unnest`, or `regexp_matches` in a context that wants one value — inside a `WHERE`/`CASE`/aggregate argument, or (on modern versions) nested inside another function call where SRFs are not allowed.

## How to fix

Move the SRF into the `FROM` clause, typically with `LATERAL`: `SELECT ... FROM t, LATERAL generate_series(...) g`. Or wrap it so it produces a set of rows rather than a value in a scalar position. `unnest` and friends belong in `FROM` (or a `SELECT` target list), not buried in a scalar expression.

## Example

*Illustrative* — a set-returning function in a scalar position.

```sql
SELECT 1 WHERE generate_series(1,3) > 1;
```

Produces:

```text
ERROR:  set-valued function called in context that cannot accept a set
```

## Related

- [materialize mode required, but it is not allowed in this context](./materialize-mode-required-but-it-is-not-allowed-in-this-context.md)
- [function returning record called in context that cannot accept type record](./function-returning-record-called-in-context-that-cannot-accept-type-record.md)
