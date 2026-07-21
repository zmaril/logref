---
message: "failed to register custom resource manager \"%s\" with ID %d"
slug: failed-to-register-custom-resource-manager-with-id
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/rmgr.c:119"
  - "postgres/src/backend/access/transam/rmgr.c:124"
  - "postgres/src/backend/access/transam/rmgr.c:136"
reproduced: false
---

# `failed to register custom resource manager "%s" with ID %d`

## What it means

An extension tried to register a custom WAL resource manager (`rmgr`) but the registration failed. The placeholders name the resource manager and the requested ID. Custom resource managers must claim a unique ID within the allowed range at load time; a conflict or out-of-range ID makes registration fail.

## When it happens

Loading an extension that registers a custom `rmgr` whose ID collides with another loaded extension's, is outside the reserved custom-ID range, or is registered too late (not during the required initialization phase).

## How to fix

Ensure the custom resource manager uses a unique ID in the reserved custom range and registers during shared-library initialization (typically via `_PG_init` with the extension in `shared_preload_libraries`). Resolve ID collisions between extensions by configuring their IDs. Consult the extension's documentation for the required setup.

## Example

*Illustrative* — a colliding custom rmgr registration.

```text
ERROR:  failed to register custom resource manager "myext" with ID 130
```

## Related

- [too much WAL data](./too-much-wal-data.md)
- [unrecognized token](./unrecognized-token.md)
