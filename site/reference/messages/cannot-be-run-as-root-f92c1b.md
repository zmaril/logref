---
message: "%s: cannot be run as root"
slug: cannot-be-run-as-root-f92c1b
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/option.c:110"
reproduced: false
---

# `%s: cannot be run as root`

## What it means

`pg_upgrade` refused to run because it was invoked by the root user. Like the server itself, `pg_upgrade` must run as the unprivileged account that owns the data directories, so upgraded files keep the correct ownership.

## When it happens

It occurs when `pg_upgrade` is launched as root instead of the database owner account.

## How to fix

Run `pg_upgrade` as the OS user that owns both the old and new data directories, typically the `postgres` account, rather than as root.

## Example

*Illustrative* — running pg_upgrade as root.

```text
pg_upgrade: cannot be run as root
```

## Related

- [cannot be run as root (initdb)](./cannot-be-run-as-root-0ebb85.md)
- [cannot check file compression not supported by this build](./cannot-check-file-compression-with-not-supported-by-this-build.md)
