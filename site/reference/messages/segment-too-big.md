---
message: "segment too big"
slug: segment-too-big
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/storage/smgr/md.c:1265"
  - "postgres/src/backend/storage/smgr/md.c:1807"
reproduced: false
---

# `segment too big`

## What it means

Internal error. A memory or storage segment whose size is encoded in a bounded field was asked to be larger than that field can represent, so the allocation/format cannot proceed.

## When it happens

It fires from low-level allocation or serialization code (for example sort/hash spill or a codec) when a requested segment exceeds an internal maximum. Ordinary SQL does not usually reach it directly.

## How to fix

This is an internal limit guard. If a real workload triggers it, reduce the size of the operation involved (smaller batches, `work_mem` tuning where relevant) and capture the case; the hard cap itself is not user-configurable.

## Example

*Illustrative* — a segment larger than the format allows.

```text
FATAL:  segment too big
```

## Related

- [overflow - encode estimate too small](./overflow-encode-estimate-too-small.md)
- [too many registered buffers](./too-many-registered-buffers.md)
