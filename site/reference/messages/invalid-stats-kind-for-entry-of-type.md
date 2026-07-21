---
message: "invalid stats kind %u for entry of type %c"
slug: invalid-stats-kind-for-entry-of-type
passthrough: false
api: [elog]
level: [WARNING]
call_sites:
  - "postgres/src/backend/utils/activity/pgstat.c:1908"
  - "postgres/src/backend/utils/activity/pgstat.c:2004"
reproduced: false
---

# `invalid stats kind %u for entry of type %c`

## What it means

A warning that statistics-import processing met a statistics-kind value that is not valid for the entry type it was reading, so it skipped that component.

## When it happens

It arises during statistics import when a stats-kind marker does not match the entry's type — often a version or format difference between source and target.

## Is this a problem?

Usually the import continues, skipping the invalid component; the planner rebuilds statistics on the next `ANALYZE`. Run `ANALYZE` on the affected objects if current statistics are needed.

## Example

*Illustrative* — an invalid stats kind.

```text
WARNING:  invalid stats kind 9 for entry of type r
```

## Related

- [could not read stats kind for entry of type %c](./could-not-read-stats-kind-for-entry-of-type.md)
- [could not find information of kind %u for entry of type %c](./could-not-find-information-of-kind-for-entry-of-type.md)
