---
message: "key (%u, %u) -> %u"
slug: key
passthrough: false
api: [elog]
level: [DEBUG3]
call_sites:
  - "postgres/contrib/amcheck/verify_gin.c:309"
  - "postgres/contrib/amcheck/verify_gin.c:314"
reproduced: false
---

# `key (%u, %u) -> %u`

## What it means

A very-high-level debug trace line printing a hash-table key mapping, used when tracing internal hashing.

## When it happens

It appears only at the highest debug levels in code that traces hash-table probes, emitting a key and the slot it maps to.

## Is this a problem?

No action is needed. It is low-level internal tracing visible only at the highest debug levels. Lower the log level to silence it.

## Example

*Illustrative* — a hash-key trace line.

```text
DEBUG:  key (16401, 2) -> 5
```

## Related

- [kill(%ld,%d) failed: %m](./kill-failed.md)
- [begin tuple sort: nkeys = %d, workMem = %d, randomAccess = %c](./begin-tuple-sort-nkeys-workmem-randomaccess.md)
