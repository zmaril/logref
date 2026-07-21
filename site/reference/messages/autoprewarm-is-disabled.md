---
message: "autoprewarm is disabled"
slug: autoprewarm-is-disabled
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/contrib/pg_prewarm/autoprewarm.c:829"
reproduced: false
---

# `autoprewarm is disabled`

## What it means

A `pg_prewarm` autoprewarm control function was called while the autoprewarm background worker is not running. Those functions act on the worker, so they require it to be enabled.

## When it happens

It occurs when `autoprewarm_dump_now()` or a related function runs but `pg_prewarm.autoprewarm` is off or the worker did not start.

## How to fix

Enable the worker by setting `pg_prewarm.autoprewarm = on` and confirming `pg_prewarm` is in `shared_preload_libraries`, then restart. Once the worker is running, the control functions succeed.

## Example

*Illustrative* — calling a dump function with the worker off.

```text
ERROR:  autoprewarm is disabled
```

## Related

- [autoprewarm block dump file is corrupted at line](./autoprewarm-block-dump-file-is-corrupted-at-line.md)
- [backup is not in progress](./backup-is-not-in-progress.md)
