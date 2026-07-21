---
message: "local buffer hash table corrupted"
slug: local-buffer-hash-table-corrupted
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/buffer/localbuf.c:160"
  - "postgres/src/backend/storage/buffer/localbuf.c:669"
reproduced: false
---

# `local buffer hash table corrupted`

## What it means

Internal error. The hash table that tracks local (temp-table) buffers is in an inconsistent state — a lookup found a mapping that does not match its buffer. It is a consistency guard over the local buffer manager.

## When it happens

It fires while managing buffers for temporary tables when the local buffer lookup table is inconsistent. Ordinary temp-table use does not surface it; it points to memory corruption or an internal bug.

## How to fix

This is a can't-happen guard. Capture the workload (especially temp-table usage) and report a reproducible case. If it appears alongside crashes or other corruption, investigate the host's memory.

## Example

*Illustrative* — an inconsistent local buffer hash table.

```text
ERROR:  local buffer hash table corrupted
```

## Related

- [locallock table corrupted](./locallock-table-corrupted.md)
- [lock on object is already held](./lock-on-object-is-already-held.md)
