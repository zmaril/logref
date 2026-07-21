---
message: "index \"%s\" contains an inner tuple marked as invalid"
slug: index-contains-an-inner-tuple-marked-as-invalid
passthrough: false
api: [ereport]
level: [ERROR, LOG]
call_sites:
  - "postgres/src/backend/access/gist/gist.c:764"
  - "postgres/src/backend/access/gist/gistvacuum.c:462"
reproduced: false
---

# `index "%s" contains an inner tuple marked as invalid`

## What it means

While scanning an SP-GiST index, the code found an inner tuple whose header is marked invalid — a state that should never be reached during a normal read. It signals index corruption or an interrupted index operation.

## When it happens

It is reported when an SP-GiST index scan or `amcheck` walks a tree and encounters an inner tuple flagged invalid. It does not come from ordinary data; it points to a damaged index or one left inconsistent by a crash during a page split.

## How to fix

Rebuild the index with `REINDEX INDEX`. If the error recurs after a rebuild, suspect underlying storage problems: check the server log for I/O errors and verify the hardware. Capture the index name and the operation that triggered it.

## Example

*Illustrative* — a scan meeting an invalid inner tuple.

```text
ERROR:  index "my_spgist_idx" contains an inner tuple marked as invalid
```

## Related

- [line pointer points past end of tuple space in index](./line-pointer-points-past-end-of-tuple-space-in-index.md)
- [invalid line pointer storage in index](./invalid-line-pointer-storage-in-index.md)
