---
message: "BUFFER_USAGE_LIMIT cannot be specified for VACUUM FULL"
slug: buffer-usage-limit-cannot-be-specified-for-vacuum-full
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/vacuum.c:335"
reproduced: true
---

# `BUFFER_USAGE_LIMIT cannot be specified for VACUUM FULL`

## What it means

A `VACUUM` command combined `FULL` with `BUFFER_USAGE_LIMIT`. The buffer-usage limit controls the buffer-access ring size used by regular vacuum, but `VACUUM FULL` rewrites the table through a different path that does not use that ring.

## When it happens

It occurs when running `VACUUM (FULL, BUFFER_USAGE_LIMIT '...') table`, or the same combination via `vacuumdb`.

## How to fix

Drop `BUFFER_USAGE_LIMIT` when using `FULL`, or drop `FULL` if you want to bound buffer usage. The option applies to standard vacuum, not to the full-table rewrite that `VACUUM FULL` performs.

## Example

*Reproduced* — captured from `reproducers/scenarios/53_vacuum_cluster_concurrency_ddl.sql`.

```sql
VACUUM (FULL, BUFFER_USAGE_LIMIT '256kB') repro.churn;
```

Produces:

```text
ERROR:  BUFFER_USAGE_LIMIT cannot be specified for VACUUM FULL
```

## Related

- [cannot accept a value of a shell type](./cannot-accept-a-value-of-a-shell-type.md)
- [calling procedures with output arguments is not supported in sql functions](./calling-procedures-with-output-arguments-is-not-supported-in-sql-functions.md)
