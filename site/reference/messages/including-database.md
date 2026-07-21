---
message: "including database \"%s\""
slug: including-database
passthrough: false
api: [pg_log_info]
level: [INFO]
call_sites:
  - "postgres/src/bin/pg_amcheck/pg_amcheck.c:1600"
  - "postgres/src/bin/pg_amcheck/pg_amcheck.c:1739"
reproduced: false
---

# `including database "%s"`

## What it means

An informational `pg_dumpall` progress line naming a database it is including in the dump.

## When it happens

It arises during a verbose `pg_dumpall` as it iterates the cluster's databases and dumps each one.

## Is this a problem?

No action is needed. It is dump-progress output. It confirms which databases the dump covers.

## Example

*Illustrative* — including a database in a dump.

```text
INFO:  including database "app"
```

## Related

- [executing %s](./executing-ddcf88.md)
- [done](./done.md)
