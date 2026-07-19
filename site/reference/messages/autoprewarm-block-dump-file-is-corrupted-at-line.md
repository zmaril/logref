---
message: "autoprewarm block dump file is corrupted at line %d"
slug: autoprewarm-block-dump-file-is-corrupted-at-line
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/contrib/pg_prewarm/autoprewarm.c:357"
reproduced: false
---

# `autoprewarm block dump file is corrupted at line %d`

## What it means

The `pg_prewarm` autoprewarm worker read its saved block-dump file and found a malformed entry. The placeholder is the line number. The file lists blocks to reload into shared buffers at startup, and a line that does not parse stops the load.

## When it happens

It occurs when the autoprewarm worker starts and reads `autoprewarm.blocks`, if that file was truncated, hand-edited, or damaged.

## How to fix

The dump file is a cache, not authoritative data. Remove or let the worker rewrite `autoprewarm.blocks`; a fresh dump is written on the next clean shutdown or dump cycle. Losing it only means the prewarm hint is skipped once.

## Example

*Illustrative* — a corrupt dump line.

```text
ERROR:  autoprewarm block dump file is corrupted at line 42
```

## Related

- [autoprewarm is disabled](./autoprewarm-is-disabled.md)
- [block number is out of range for relation](./block-number-is-out-of-range-for-relation.md)
