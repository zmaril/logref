---
message: "function returning record called in context that cannot accept type record"
slug: function-returning-record-called-in-context-that-cannot-accept-type-record
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/contrib/dblink/dblink.c:905"
  - "postgres/contrib/dblink/dblink.c:1199"
  - "postgres/contrib/sslinfo/sslinfo.c:381"
  - "postgres/contrib/tablefunc/tablefunc.c:435"
  - "postgres/src/backend/statistics/mcv.c:1364"
  - "postgres/src/pl/plpython/plpy_exec.c:233"
  - "postgres/src/pl/tcl/pltcl.c:1019"
reproduced: false
---

# `function returning record called in context that cannot accept type record`

## What it means

A function that returns the generic `record` type was called somewhere that cannot determine the record's column structure. Because `record` has no fixed shape, the caller must describe the columns, and this context does not allow that.

## When it happens

Calling a `RETURNS record` or `RETURNS SETOF record` function (like `dblink`, `json_populate_record` variants, or a PL function) without a column definition list, or in a scalar position where the row shape cannot be supplied.

## How to fix

Provide a column definition list in the `FROM` clause: `SELECT * FROM myfunc(...) AS t(col1 int, col2 text)`. That tells Postgres the record's structure. Do not call `record`-returning functions in scalar contexts; place them in `FROM` with the `AS (...)` list describing the columns.

## Example

*Illustrative* — a record-returning function without a column list.

```sql
SELECT dblink('dbname=x', 'SELECT a, b FROM t');
```

Produces:

```text
ERROR:  function returning record called in context that cannot accept type record
```

## Related

- [materialize mode required, but it is not allowed in this context](./materialize-mode-required-but-it-is-not-allowed-in-this-context.md)
- [set-valued function called in context that cannot accept a set](./set-valued-function-called-in-context-that-cannot-accept-a-set.md)
