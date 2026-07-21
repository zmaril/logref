---
message: "failed to register custom cumulative statistics \"%s\" with ID %u"
slug: failed-to-register-custom-cumulative-statistics-with-id-bf479d
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/activity/pgstat.c:1518"
  - "postgres/src/backend/utils/activity/pgstat.c:1523"
  - "postgres/src/backend/utils/activity/pgstat.c:1534"
  - "postgres/src/backend/utils/activity/pgstat.c:1538"
  - "postgres/src/backend/utils/activity/pgstat.c:1543"
  - "postgres/src/backend/utils/activity/pgstat.c:1548"
  - "postgres/src/backend/utils/activity/pgstat.c:1553"
  - "postgres/src/backend/utils/activity/pgstat.c:1560"
  - "postgres/src/backend/utils/activity/pgstat.c:1578"
  - "postgres/src/backend/utils/activity/pgstat.c:1591"
reproduced: false
---

# `failed to register custom cumulative statistics "%s" with ID %u`

## What it means

Internal/extension error. An extension tried to register a custom cumulative statistics kind (a feature that lets extensions add to the cumulative statistics system) with a name/ID that could not be registered — usually a duplicate ID or a registration done at the wrong time. The placeholders are the name and ID.

## When it happens

Loading an extension that registers custom stats with an ID that collides with another extension's, or that calls the registration API outside the allowed initialization window (it must happen at `shared_preload_libraries` load time). Only affects clusters running such extensions.

## How to fix

This is an extension configuration/coding issue. Ensure conflicting extensions do not claim the same custom-stats ID, and that the extension is listed in `shared_preload_libraries` so it registers at the right time. Update or report the extension if it mismanages registration. Ordinary users cannot trigger it.

## Example

*Illustrative* — two extensions claiming the same stats ID.

```text
ERROR:  failed to register custom cumulative statistics "myext" with ID 128
```

## Related

- [out of shared memory](./out-of-shared-memory.md)
- [hash table corrupted](./hash-table-corrupted-ef89f9.md)
