---
message: "backend is incorrectly linked to frontend functions"
slug: backend-is-incorrectly-linked-to-frontend-functions
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/bootstrap/bootstrap.c:415"
reproduced: false
---

# `backend is incorrectly linked to frontend functions`

## What it means

Server code detected that it is linked against the frontend build of a shared routine instead of the backend build. The two builds share names but differ in behavior, and mixing them is a link-time mistake.

## When it happens

It is a guard against a mis-built or mis-loaded module. It can appear when a loadable module was compiled against the wrong support library.

## How to fix

This is a build or packaging problem, not a data issue. Rebuild the offending extension against the matching server headers, ensure it links the backend variant, and confirm the module and server come from the same Postgres version.

## Example

*Illustrative* — the link-time guard.

```text
ERROR:  backend is incorrectly linked to frontend functions
```

## Related

- [binary I/O not supported during bootstrap](./binary-i-o-not-supported-during-bootstrap.md)
- [authentication identifier set more than once](./authentication-identifier-set-more-than-once.md)
