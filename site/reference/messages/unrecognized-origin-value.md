---
message: "unrecognized origin value: \"%s\""
slug: unrecognized-origin-value
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/subscriptioncmds.c:395"
  - "postgres/src/backend/replication/pgoutput/pgoutput.c:415"
reproduced: false
---

# `unrecognized origin value: "%s"`

## What it means

A replication-origin function or setting was given an origin name or value that does not resolve to a known replication origin.

## When it happens

It arises from `pg_replication_origin_*` functions and the `replication_origin` context when the named origin was never created, was dropped, or is misspelled.

## How to fix

Create the origin with `pg_replication_origin_create()` before using it, or reference an existing name from `pg_replication_origin`. Check spelling; origin names are case-sensitive text.

## Example

*Illustrative* — referencing a non-existent origin.

```text
ERROR:  unrecognized origin value: "pg_16401"
```

## Related

- [unrecognized streaming header: "%c"](./unrecognized-streaming-header.md)
- [unrecognized encoding: "%s"](./unrecognized-encoding-6df687.md)
