---
message: "could not perform block dump because dump file is being used by PID %d"
slug: could-not-perform-block-dump-because-dump-file-is-being-used-by-pid
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/contrib/pg_prewarm/autoprewarm.c:695"
reproduced: false
---

# `could not perform block dump because dump file is being used by PID %d`

## What it means

The `pg_prewarm` autoprewarm feature was asked to write out the list of currently cached blocks, but another process is already writing that dump file. The `%d` value is the process ID holding it. Only one dump may be in progress at a time.

## When it happens

It happens when calling `autoprewarm_dump_now()` while the background autoprewarm worker (or another call) is already dumping the shared-buffer block list to disk.

## How to fix

Wait for the in-progress dump to finish and retry, rather than triggering two at once. The autoprewarm worker dumps periodically on its own, so a manual dump is only needed occasionally; avoid overlapping calls.

## Example

*Illustrative* — a concurrent autoprewarm dump.

```sql
SELECT autoprewarm_dump_now();
-- ERROR:  could not perform block dump because dump file is being used by PID 4123
```

## Related

- [could not prefetch relation block](./could-not-prefetch-relation-block.md)
- [could not print result table](./could-not-print-result-table.md)
