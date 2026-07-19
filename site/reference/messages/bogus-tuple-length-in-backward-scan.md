---
message: "bogus tuple length in backward scan"
slug: bogus-tuple-length-in-backward-scan
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/sort/tuplesort.c:1512"
  - "postgres/src/backend/utils/sort/tuplesort.c:1525"
reproduced: false
---

# `bogus tuple length in backward scan`

## What it means

Internal error. The sort machinery reading spilled tuples backward found a tuple-length value that does not make sense. It is a consistency check on temporary sort data being read in reverse.

## When it happens

It should not occur in normal operation. Reaching it points to corrupt temporary sort files or an internal inconsistency, rather than to your query.

## How to fix

Check the temporary file storage first: ensure the temp tablespace or data directory temp area has healthy disks and space, since a damaged spill file can produce it. If storage is sound, capture the query and report it as a possible internal bug.

## Example

*Illustrative* — a bad tuple length in a backward scan.

```text
ERROR:  bogus tuple length in backward scan
```

## Related

- [unexpected eof for tape requested bytes read bytes](./unexpected-eof-for-tape-requested-bytes-read-bytes.md)
- [could not create temporary file](./could-not-create-temporary-file.md)
