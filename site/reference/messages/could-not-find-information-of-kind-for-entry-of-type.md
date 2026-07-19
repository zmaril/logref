---
message: "could not find information of kind %u for entry of type %c"
slug: could-not-find-information-of-kind-for-entry-of-type
passthrough: false
api: [elog]
level: [WARNING]
call_sites:
  - "postgres/src/backend/utils/activity/pgstat.c:1916"
  - "postgres/src/backend/utils/activity/pgstat.c:2012"
reproduced: false
---

# `could not find information of kind %u for entry of type %c`

## What it means

A warning that statistics-import processing could not find information of a given kind for a catalog entry of a given type, so it skipped that piece.

## When it happens

It arises when importing statistics (for example during upgrade or a stats-transfer path) and an expected statistics component for an entry is absent — often a version difference between source and target.

## Is this a problem?

Usually the import continues, skipping the missing piece; the planner rebuilds statistics on the next `ANALYZE`. If accurate statistics matter immediately, run `ANALYZE` on the affected objects after the import.

## Example

*Illustrative* — missing statistics information for an entry.

```text
WARNING:  could not find information of kind 1 for entry of type r
```

## Related

- [could not read stats kind for entry of type %c](./could-not-read-stats-kind-for-entry-of-type.md)
- [invalid stats kind %u for entry of type %c](./invalid-stats-kind-for-entry-of-type.md)
