---
message: "error while copying relation \"%s.%s\": could not open file \"%s\": %m"
slug: error-while-copying-relation-could-not-open-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/file.c:87"
  - "postgres/src/bin/pg_upgrade/file.c:156"
reproduced: false
---

# `error while copying relation "%s.%s": could not open file "%s": %m`

## What it means

`pg_upgrade` could not open the source file while copying a relation into the new cluster. The `%s` values are the relation and file and the `%m` is the operating-system error.

## When it happens

A source relation file was missing or unreadable, or permissions blocked access, while `pg_upgrade` transferred storage from the old cluster.

## How to fix

Read the trailing error. Confirm the old cluster is intact and readable by the upgrade user and was shut down cleanly before the upgrade. Fix access and rerun.

## Example

*Illustrative* — a source relation file could not be opened.

```text
error while copying relation "public.t": could not open file "/old/base/16384/16390": Permission denied
```

## Related

- [error while copying relation: could not create file](./error-while-copying-relation-could-not-create-file.md)
- [could not open source file](./could-not-open-source-file.md)
