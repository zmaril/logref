---
message: "dsa_area space must be at least %zu, but %zu provided"
slug: dsa-area-space-must-be-at-least-but-provided
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/mmgr/dsa.c:1289"
reproduced: false
---

# `dsa_area space must be at least %zu, but %zu provided`

## What it means

An internal guard in the dynamic-shared-area code. `dsa_create_in_place` was given a memory region smaller than the minimum an area needs. The placeholders are the required and provided sizes. This is a "can't happen" sizing check.

## When it happens

It fires when DSA-using code creates an area inside a region that is too small to hold the area's control structures.

## How to fix

This is not a user-facing condition. If it comes from an extension, that extension sizes its shared-memory region too small for the DSA it creates. Capture the log and server version and report a reproducible case to the PostgreSQL developers.

## Example

*Illustrative* — the guard as it appears in the log.

```text
ERROR:  dsa_area space must be at least 1024, but 512 provided
```

## Related

- [dsa_area not pinned](./dsa-area-not-pinned.md)
- [DSA name too long](./dsa-name-too-long.md)
