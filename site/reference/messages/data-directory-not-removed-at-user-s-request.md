---
message: "data directory \"%s\" not removed at user's request"
slug: data-directory-not-removed-at-user-s-request
passthrough: false
api: [pg_log_info]
level: [INFO]
call_sites:
  - "postgres/src/bin/initdb/initdb.c:814"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:273"
reproduced: false
---

# `data directory "%s" not removed at user's request`

## What it means

An informational message from a tool that it did not delete a data directory because the user's options told it not to.

## When it happens

It arises from tools such as `pg_upgrade`-related cleanup or `initdb` failure handling when a directory would normally be removed but a flag (or a declined prompt) kept it in place.

## Is this a problem?

No action is needed. The directory was retained deliberately, often so you can inspect it. Remove it yourself when you no longer need it.

## Example

*Illustrative* — a retained data directory.

```text
INFO:  data directory "/tmp/newdata" not removed at user's request
```

## Related

- [including database "%s"](./including-database.md)
- [done](./done.md)
