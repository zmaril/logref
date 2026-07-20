---
message: "system catalog scans with lossy index conditions are not implemented"
slug: system-catalog-scans-with-lossy-index-conditions-are-not-implemented
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/index/genam.c:537"
  - "postgres/src/backend/access/index/genam.c:744"
reproduced: false
---

# `system catalog scans with lossy index conditions are not implemented`

## What it means

Internal error. A system catalog scan was set up with an index condition that would be lossy (requiring rechecking of returned rows), which the catalog-scan code does not support. Catalog scans require exact index conditions.

## When it happens

It fires from system-cache/catalog scanning code when a scan key that cannot be applied exactly by the index is encountered. Ordinary user queries do not hit it; it concerns internal catalog access.

## How to fix

This is an internal limitation guard. If a real operation triggers it, capture the operation (often an extension performing unusual catalog access) and report it; there is no user-facing setting to change.

## Example

*Illustrative* — a lossy index condition on a catalog scan.

```text
ERROR:  system catalog scans with lossy index conditions are not implemented
```

## Related

- [scan started during logical decoding](./scan-started-during-logical-decoding.md)
- [subquery is bogus](./subquery-is-bogus.md)
