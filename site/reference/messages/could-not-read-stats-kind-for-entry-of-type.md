---
message: "could not read stats kind for entry of type %c"
slug: could-not-read-stats-kind-for-entry-of-type
passthrough: false
api: [elog]
level: [WARNING]
call_sites:
  - "postgres/src/backend/utils/activity/pgstat.c:1902"
  - "postgres/src/backend/utils/activity/pgstat.c:1993"
reproduced: false
---

# `could not read stats kind for entry of type %c`

## What it means

A warning that statistics-import processing could not read the statistics-kind marker for a catalog entry of a given type, so it skipped that component.

## When it happens

It arises during statistics import when a stats-kind value cannot be read for an entry — often a version or format difference between source and target.

## Is this a problem?

Usually the import continues, skipping the unreadable component; the planner rebuilds statistics on the next `ANALYZE`. Run `ANALYZE` on the affected objects if current statistics are needed.

## Example

*Illustrative* — an unreadable stats kind.

```text
WARNING:  could not read stats kind for entry of type r
```

## Related

- [could not find information of kind %u for entry of type %c](./could-not-find-information-of-kind-for-entry-of-type.md)
- [invalid stats kind %u for entry of type %c](./invalid-stats-kind-for-entry-of-type.md)
