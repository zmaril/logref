---
message: "index relfilenumber value not set when in binary upgrade mode"
slug: index-relfilenumber-value-not-set-when-in-binary-upgrade-mode
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/catalog/index.c:956"
  - "postgres/src/backend/utils/cache/relcache.c:3797"
reproduced: false
---

# `index relfilenumber value not set when in binary upgrade mode`

## What it means

Internal error specific to binary-upgrade mode. `pg_upgrade` preassigns relfilenumbers so new-cluster objects keep their file identities, and this guard fired because an index was created without that preassigned value being set first.

## When it happens

It only occurs under `pg_upgrade`, which runs the backend in binary-upgrade mode and calls `binary_upgrade_set_next_index_relfilenode()` before each `CREATE INDEX`. Reaching the error means that preassignment step was skipped or out of order.

## How to fix

This does not arise in normal operation. It points to a bug or an interrupted/hand-edited `pg_upgrade` run. Do not run backends in binary-upgrade mode by hand; rerun `pg_upgrade` from a clean dump, and report a reproducible case if it persists.

## Example

*Illustrative* — an index created in upgrade mode without a preassigned relfilenumber.

```text
ERROR:  index relfilenumber value not set when in binary upgrade mode
```

## Related

- [invalid data in history file](./invalid-data-in-history-file-df2123.md)
- [is not a valid data directory](./is-not-a-valid-data-directory.md)
