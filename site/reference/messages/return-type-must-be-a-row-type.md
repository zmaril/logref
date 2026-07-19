---
message: "return type must be a row type"
slug: return-type-must-be-a-row-type
passthrough: false
api: [elog, ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/contrib/dblink/dblink.c:912"
  - "postgres/contrib/dblink/dblink.c:1206"
  - "postgres/contrib/hstore/hstore_op.c:869"
  - "postgres/contrib/pageinspect/brinfuncs.c:366"
  - "postgres/contrib/pageinspect/btreefuncs.c:298"
  - "postgres/contrib/pageinspect/btreefuncs.c:438"
  - "postgres/contrib/pageinspect/btreefuncs.c:688"
  - "postgres/contrib/pageinspect/btreefuncs.c:804"
  - "postgres/contrib/pageinspect/btreefuncs.c:885"
  - "postgres/contrib/pageinspect/ginfuncs.c:68"
  - "postgres/contrib/pageinspect/ginfuncs.c:131"
  - "postgres/contrib/pageinspect/ginfuncs.c:229"
  - "postgres/contrib/pageinspect/gistfuncs.c:98"
  - "postgres/contrib/pageinspect/hashfuncs.c:263"
  - "postgres/contrib/pageinspect/hashfuncs.c:338"
  - "postgres/contrib/pageinspect/hashfuncs.c:497"
  - "postgres/contrib/pageinspect/hashfuncs.c:542"
  - "postgres/contrib/pageinspect/heapfuncs.c:154"
  - "postgres/contrib/pageinspect/heapfuncs.c:534"
  - "postgres/contrib/pageinspect/rawpage.c:271"
  - "postgres/contrib/pg_buffercache/pg_buffercache_pages.c:104"
  - "postgres/contrib/pg_buffercache/pg_buffercache_pages.c:394"
  - "postgres/contrib/pg_buffercache/pg_buffercache_pages.c:587"
  - "postgres/contrib/pg_buffercache/pg_buffercache_pages.c:710"
  - "postgres/contrib/pg_buffercache/pg_buffercache_pages.c:746"
  - "postgres/contrib/pg_buffercache/pg_buffercache_pages.c:793"
  - "postgres/contrib/pg_buffercache/pg_buffercache_pages.c:827"
  - "postgres/contrib/pg_buffercache/pg_buffercache_pages.c:863"
  - "postgres/contrib/pg_buffercache/pg_buffercache_pages.c:909"
  - "postgres/contrib/pg_logicalinspect/pg_logicalinspect.c:113"
  - "postgres/contrib/pg_logicalinspect/pg_logicalinspect.c:148"
  - "postgres/contrib/pg_stat_statements/pg_stat_statements.c:2051"
  - "postgres/contrib/pg_visibility/pg_visibility.c:289"
  - "postgres/contrib/pg_walinspect/pg_walinspect.c:497"
  - "postgres/contrib/pgcrypto/pgp-pgsql.c:937"
  - "postgres/contrib/pgstattuple/pgstatapprox.c:318"
  - "postgres/contrib/pgstattuple/pgstatindex.c:365"
  - "postgres/contrib/pgstattuple/pgstatindex.c:586"
  - "postgres/contrib/pgstattuple/pgstatindex.c:767"
  - "postgres/contrib/pgstattuple/pgstattuple.c:109"
  - "postgres/contrib/tablefunc/tablefunc.c:442"
  - "postgres/src/backend/access/transam/commit_ts.c:443"
  - "postgres/src/backend/access/transam/commit_ts.c:487"
  - "postgres/src/backend/access/transam/xlogfuncs.c:166"
  - "postgres/src/backend/access/transam/xlogfuncs.c:523"
  - "postgres/src/backend/access/transam/xlogfuncs.c:815"
  - "postgres/src/backend/backup/walsummaryfuncs.c:194"
  - "postgres/src/backend/catalog/objectaddress.c:2475"
  - "postgres/src/backend/catalog/objectaddress.c:4521"
  - "postgres/src/backend/catalog/objectaddress.c:4638"
  - "postgres/src/backend/commands/sequence.c:1762"
  - "postgres/src/backend/replication/slotfuncs.c:89"
  - "postgres/src/backend/replication/slotfuncs.c:203"
  - "postgres/src/backend/replication/slotfuncs.c:558"
  - "postgres/src/backend/replication/slotfuncs.c:647"
  - "postgres/src/backend/replication/walreceiver.c:1502"
  - "postgres/src/backend/tsearch/wparser.c:69"
  - "postgres/src/backend/tsearch/wparser.c:209"
  - "postgres/src/backend/utils/adt/datetime.c:5193"
  - "postgres/src/backend/utils/adt/datetime.c:5280"
  - "postgres/src/backend/utils/adt/misc.c:404"
  - "postgres/src/backend/utils/adt/misc.c:483"
  - "postgres/src/backend/utils/adt/misc.c:699"
  - "postgres/src/backend/utils/adt/multixactfuncs.c:65"
  - "postgres/src/backend/utils/adt/multixactfuncs.c:107"
  - "postgres/src/backend/utils/adt/partitionfuncs.c:91"
  - "postgres/src/backend/utils/adt/tsvector_op.c:648"
  - "postgres/src/backend/utils/adt/tsvector_op.c:2455"
  - "postgres/src/backend/utils/fmgr/funcapi.c:109"
  - "postgres/src/backend/utils/misc/pg_controldata.c:42"
  - "postgres/src/backend/utils/misc/pg_controldata.c:82"
  - "postgres/src/backend/utils/misc/pg_controldata.c:173"
  - "postgres/src/backend/utils/misc/pg_controldata.c:214"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:747"
  - "postgres/src/pl/tcl/pltcl.c:1026"
reproduced: false
---

# `return type must be a row type`

## What it means

A set-returning or record-returning function was defined or called such that its declared return type is not a composite (row) type when a composite type is required. Many built-in functions that emit rows insist the caller describe the expected row shape, and this fires when that shape is a scalar or otherwise not a row type.

## When it happens

Calling a function that returns `record` or `SETOF record` without a proper column definition list, or defining a function `RETURNS <scalar>` where the body or framework needs a row type. It is common with `crosstab`, `json_to_record`, `dblink`, and similar functions when the `AS (col type, ...)` clause is missing or wrong.

## How to fix

Give the call a column definition list that is a row type: `SELECT * FROM myfunc(...) AS t(col1 int, col2 text)`. If you are defining the function, declare it to return an existing composite type, a table row type, or `TABLE(...)`. Make sure the alias list actually describes multiple typed columns rather than a single scalar.

## Example

*Illustrative* — a record-returning function called without a column list.

```sql
SELECT * FROM json_to_record('{"a":1}');
```

Produces:

```text
ERROR:  record type has not been registered
```

(The related "return type must be a row type" fires when the supplied definition is a scalar rather than a row.)

## Related

- [function returning record called in context that cannot accept type record](./function-returning-record-called-in-context-that-cannot-accept-type-record.md)
- [a column definition list is required for functions returning record](./materialize-mode-required-but-it-is-not-allowed-in-this-context.md)
