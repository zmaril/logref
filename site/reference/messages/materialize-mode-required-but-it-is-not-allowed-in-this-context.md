---
message: "materialize mode required, but it is not allowed in this context"
slug: materialize-mode-required-but-it-is-not-allowed-in-this-context
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/contrib/dblink/dblink.c:847"
  - "postgres/contrib/tablefunc/tablefunc.c:386"
  - "postgres/contrib/tablefunc/tablefunc.c:655"
  - "postgres/contrib/tablefunc/tablefunc.c:1002"
  - "postgres/contrib/tablefunc/tablefunc.c:1081"
  - "postgres/src/backend/utils/adt/jsonfuncs.c:4059"
  - "postgres/src/backend/utils/fmgr/funcapi.c:92"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:663"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:3718"
  - "postgres/src/pl/tcl/pltcl.c:846"
reproduced: false
---

# `materialize mode required, but it is not allowed in this context`

## What it means

A set-returning function that returns its whole result at once (materialize mode) was called in a place that cannot accept a materialized set. Some SRFs (`dblink`, `jsonb_each`, PL functions returning `SETOF`) only support materialize mode, and the calling context does not allow it.

## When it happens

Using such a function in a scalar or value-per-call context instead of the `FROM` clause — for example nesting it where only a single value fits, or in an expression that expects value-per-call SRF semantics. Modern Postgres requires these SRFs in the `FROM` list.

## How to fix

Call the function in the `FROM` clause (often with `LATERAL`): `SELECT ... FROM t, LATERAL myfunc(...) f`. Do not place a materialize-mode SRF in a scalar expression or a `SELECT` target where value-per-call is required. This is the standard placement for `dblink`, `json*_each`, and `SETOF`-returning PL functions.

## Example

*Illustrative* — a materialize-mode SRF in the wrong context.

```sql
SELECT (jsonb_each('{"a":1}')).key WHERE true;
```

Produces:

```text
ERROR:  materialize mode required, but it is not allowed in this context
```

## Related

- [set-valued function called in context that cannot accept a set](./set-valued-function-called-in-context-that-cannot-accept-a-set.md)
- [function returning record called in context that cannot accept type record](./function-returning-record-called-in-context-that-cannot-accept-type-record.md)
