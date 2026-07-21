---
message: "binary I/O not supported during bootstrap"
slug: binary-i-o-not-supported-during-bootstrap
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/cache/lsyscache.c:2679"
reproduced: false
---

# `binary I/O not supported during bootstrap`

## What it means

Bootstrap mode tried to use a type's binary input or output routines, which are not available while the initial catalogs are being built. Bootstrap works in text only.

## When it happens

It is an internal condition that appears only during `initdb`-time bootstrap processing, not in a running server.

## How to fix

This is not reachable from normal SQL. If it appears during `initdb` or a custom bootstrap step, it points at a build or catalog-definition problem; report it with the exact bootstrap step and server version.

## Example

*Illustrative* — binary I/O attempted at bootstrap.

```text
ERROR:  binary I/O not supported during bootstrap
```

## Related

- [backend is incorrectly linked to frontend functions](./backend-is-incorrectly-linked-to-frontend-functions.md)
- [binary data has type instead of expected in record column](./binary-data-has-type-instead-of-expected-in-record-column.md)
