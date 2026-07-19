---
message: "%d: controldata retrieval problem"
slug: controldata-retrieval-problem
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/controldata.c:216"
  - "postgres/src/bin/pg_upgrade/controldata.c:226"
  - "postgres/src/bin/pg_upgrade/controldata.c:234"
  - "postgres/src/bin/pg_upgrade/controldata.c:245"
  - "postgres/src/bin/pg_upgrade/controldata.c:256"
  - "postgres/src/bin/pg_upgrade/controldata.c:267"
  - "postgres/src/bin/pg_upgrade/controldata.c:278"
  - "postgres/src/bin/pg_upgrade/controldata.c:289"
  - "postgres/src/bin/pg_upgrade/controldata.c:300"
  - "postgres/src/bin/pg_upgrade/controldata.c:303"
  - "postgres/src/bin/pg_upgrade/controldata.c:307"
  - "postgres/src/bin/pg_upgrade/controldata.c:317"
  - "postgres/src/bin/pg_upgrade/controldata.c:329"
  - "postgres/src/bin/pg_upgrade/controldata.c:340"
  - "postgres/src/bin/pg_upgrade/controldata.c:351"
  - "postgres/src/bin/pg_upgrade/controldata.c:362"
  - "postgres/src/bin/pg_upgrade/controldata.c:373"
  - "postgres/src/bin/pg_upgrade/controldata.c:384"
  - "postgres/src/bin/pg_upgrade/controldata.c:395"
  - "postgres/src/bin/pg_upgrade/controldata.c:406"
  - "postgres/src/bin/pg_upgrade/controldata.c:417"
  - "postgres/src/bin/pg_upgrade/controldata.c:428"
  - "postgres/src/bin/pg_upgrade/controldata.c:439"
  - "postgres/src/bin/pg_upgrade/controldata.c:450"
  - "postgres/src/bin/pg_upgrade/controldata.c:459"
reproduced: false
---

# `%d: controldata retrieval problem`

## What it means

A tool (notably `pg_upgrade`) failed to read or parse the cluster's control data via `pg_controldata`. The placeholder is an internal step/line number. The control file describes the cluster's state and layout; if it cannot be read, the tool cannot proceed safely.

## When it happens

Running `pg_upgrade` against a data directory whose `pg_controldata` output is missing expected fields — usually a version mismatch between the `pg_controldata` binary and the cluster, a corrupted control file, or pointing the tool at the wrong data directory.

## How to fix

Confirm you are using the `pg_controldata` binary that matches the target cluster version and that `--old-datadir`/`--new-datadir` point at the correct directories. Run `pg_controldata <datadir>` by hand to see whether it succeeds and what it reports. A control file that will not parse at all suggests corruption — investigate before attempting the upgrade.

## Example

*Illustrative* — a version/path mismatch during upgrade.

```text
FATAL:  12: controldata retrieval problem
```

## Related

- [database files are incompatible with server](./database-files-are-incompatible-with-server.md)
- [could not read file: read %d of %zu](./could-not-read-file-read-of-345e80.md)
