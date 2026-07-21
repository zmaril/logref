---
message: "CONCURRENTLY option not supported for %s"
slug: concurrently-option-not-supported-for
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/repack.c:272"
reproduced: false
---

# `CONCURRENTLY option not supported for %s`

## What it means

A `CONCURRENTLY` option was requested for an operation or object type that does not support it. The concurrent variant is unavailable in this case, so the command is rejected.

## When it happens

It happens with `REPACK`/reorganize or similar maintenance commands when `CONCURRENTLY` is applied to an object kind for which it is not implemented.

## How to fix

Run the operation without `CONCURRENTLY`, accepting the stronger lock, or target an object type that supports the concurrent form. Check the command's documentation for where `CONCURRENTLY` is allowed.

## Example

*Illustrative* — CONCURRENTLY on an unsupported target.

```text
ERROR:  CONCURRENTLY option not supported for materialized views
```

## Related

- [CONCURRENTLY cannot be used when the materialized view is not populated](./concurrently-cannot-be-used-when-the-materialized-view-is-not-populated.md)
- [concurrent index creation on system catalog tables is not supported](./concurrent-index-creation-on-system-catalog-tables-is-not-supported.md)
