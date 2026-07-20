---
message: "cannot be run as root"
slug: cannot-be-run-as-root-0ebb85
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/initdb/initdb.c:836"
reproduced: false
---

# `cannot be run as root`

## What it means

`initdb` refused to run because it was invoked by the root user. The Postgres server and its initialization tools must run as an unprivileged account, so that database files are not owned by root and the server cannot be started with superuser OS privileges.

## When it happens

It occurs when `initdb` is launched directly as root rather than as a dedicated database account.

## How to fix

Switch to an unprivileged user that owns the data directory — commonly a `postgres` OS account — and run `initdb` from there, for example with `su postgres -c 'initdb ...'`.

## Example

*Illustrative* — running initdb as root.

```text
initdb: error: cannot be run as root
```

## Related

- [cannot be run as root (pg_upgrade)](./cannot-be-run-as-root-f92c1b.md)
- [cannot cluster all databases and a specific one at the same time](./cannot-cluster-all-databases-and-a-specific-one-at-the-same-time.md)
