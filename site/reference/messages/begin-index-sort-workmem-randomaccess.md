---
message: "begin index sort: workMem = %d, randomAccess = %c"
slug: begin-index-sort-workmem-randomaccess
passthrough: false
api: [elog]
level: [LOG]
call_sites:
  - "postgres/src/backend/utils/sort/tuplesortvariants.c:510"
  - "postgres/src/backend/utils/sort/tuplesortvariants.c:565"
  - "postgres/src/backend/utils/sort/tuplesortvariants.c:599"
reproduced: false
---

# `begin index sort: workMem = %d, randomAccess = %c`

## What it means

A trace message from the sort machinery, printed when an index build begins sorting its input. It reports the working-memory budget the sort was given and whether the sort supports random access to its output. It is diagnostic output, not a problem.

## When it happens

During an index build or another operation that sorts tuples, when trace-level sort logging is enabled. It marks the start of a sort and records the memory and access mode chosen for it.

## Is this a problem?

No action is needed. It is informational trace output about a sort's configuration. If it is noisy, raise the log threshold or disable the sort tracing that produced it. The reported working-memory figure can help you judge whether more memory would let the sort stay in memory rather than spill.

## Example

*Illustrative* — a sort-start trace line.

```text
LOG:  begin index sort: workMem = 65536, randomAccess = f
```

## Related

- [bogus tuple length in backward scan](./bogus-tuple-length-in-backward-scan.md)
- [unexpected eof for tape requested bytes read bytes](./unexpected-eof-for-tape-requested-bytes-read-bytes.md)
