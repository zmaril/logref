---
message: "\"%s\" is not a valid data directory"
slug: is-not-a-valid-data-directory
passthrough: false
api: [ereport]
level: [FATAL]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/init/miscinit.c:1739"
  - "postgres/src/backend/utils/init/miscinit.c:1755"
reproduced: false
---

# `"%s" is not a valid data directory`

## What it means

A tool pointed at a directory that does not look like a Postgres data directory. The expected control file or layout is missing. The placeholder is the path.

## When it happens

It arises from tools that read a cluster's data directory — `pg_ctl`, `pg_rewind`, `pg_controldata`, `pg_upgrade`, and relatives — when the `-D`/target path is wrong, points at an empty or partial directory, or lacks `global/pg_control`.

## How to fix

Point the tool at a real data directory — the one containing `PG_VERSION`, `global/pg_control`, and the `base/` subtree. Confirm the path and that the directory was fully initialized by `initdb` and is not truncated.

## Example

*Illustrative* — a path that is not a data directory.

```text
FATAL:  "/tmp/empty" is not a valid data directory
```

## Related

- [is not a directory or symbolic link](./is-not-a-directory-or-symbolic-link.md)
- [invalid data in history file](./invalid-data-in-history-file-df2123.md)
