---
message: "could not parse version file \"%s\""
slug: could-not-parse-version-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/fe_utils/version.c:66"
reproduced: false
---

# `could not parse version file "%s"`

## What it means

A front-end tool opened a data directory's `PG_VERSION` file but could not parse its contents. The `%s` value names the file. The version file should contain a single major-version number.

## When it happens

It happens when a tool inspects a data directory whose `PG_VERSION` file is empty, corrupted, or contains unexpected text — usually a damaged file or a path that is not really a data directory.

## How to fix

Confirm the path is a genuine data directory and that `PG_VERSION` contains only the cluster's major-version number. A corrupted version file indicates a damaged data directory; investigate its integrity or restore from a backup.

## Example

*Illustrative* — an unparsable version file.

```text
pg_rewind: fatal: could not parse version file "/var/lib/pg/data/PG_VERSION"
```

## Related

- [could not open version file](./could-not-open-version-file.md)
- [could not parse server version](./could-not-parse-server-version.md)
