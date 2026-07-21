---
message: "invalid cache ID: %d"
slug: invalid-cache-id
passthrough: false
api: [elog]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/backend/utils/cache/inval.c:1818"
  - "postgres/src/backend/utils/cache/inval.c:1900"
  - "postgres/src/backend/utils/cache/syscache.c:607"
  - "postgres/src/backend/utils/cache/syscache.c:663"
  - "postgres/src/backend/utils/cache/syscache.c:676"
  - "postgres/src/backend/utils/cache/syscache.c:694"
reproduced: false
---

# `invalid cache ID: %d`

## What it means

Internal error. Code asked the system-cache (syscache) layer for a cache identified by a numeric id, and that id was outside the range of defined caches. The placeholder is the id. The syscache ids are fixed compile-time constants, so a value out of range means the caller passed a bad constant, not anything driven by data.

## When it happens

It should never occur in a correct build. In practice it points to a bug — often an out-of-tree extension using a stale or wrong syscache id, or a module built against a different server version.

## How to fix

Treat it as a bug to investigate, not a user error. If it appears only when a particular extension is loaded, suspect that extension and confirm it was built against this exact server version. Capture the statement and a stack trace and report it.

## Example

*Illustrative* — emitted internally; ordinary SQL does not trigger it.

```text
ERROR:  invalid cache ID: 999
```

## Related

- [cache lookup failed for %s %u](./cache-lookup-failed-for.md)
- [invalid relpersistence](./invalid-relpersistence.md)
