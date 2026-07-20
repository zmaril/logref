---
message: "access to noncontiguous page in hash index \"%s\""
slug: access-to-noncontiguous-page-in-hash-index
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/hash/hashpage.c:206"
reproduced: false
---

# `access to noncontiguous page in hash index "%s"`

## What it means

The hash index code tried to read a page beyond the contiguous region it expected, which indicates the hash index's internal page layout is inconsistent — an internal corruption or logic guard.

## When it happens

It is raised while traversing a hash index if the requested page number falls outside the expected contiguous set of pages, typically a sign of a damaged index.

## How to fix

Treat the affected hash index as suspect. Rebuild it with `REINDEX INDEX`, and if the problem recurs investigate storage integrity and recent crashes. This is an internal consistency check, not something a query can be rewritten to avoid.

## Example

*Illustrative* — a hash index page outside the expected range.

```text
ERROR:  access to noncontiguous page in hash index "t_c_idx"
```

## Related

- [attempt to write bogus relation mapping](./attempt-to-write-bogus-relation-mapping.md)
- [actual file length does not match expected](./actual-file-length-does-not-match-expected.md)
