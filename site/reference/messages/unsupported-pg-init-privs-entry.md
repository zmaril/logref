---
message: "unsupported pg_init_privs entry: %u %u %d"
slug: unsupported-pg-init-privs-entry
passthrough: false
api: [pg_log_warning]
level: [WARNING]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dump.c:10783"
  - "postgres/src/bin/pg_dump/pg_dump.c:10812"
reproduced: false
---

# `unsupported pg_init_privs entry: %u %u %d`

## What it means

While processing initial privileges recorded in `pg_init_privs`, the server found an entry whose object class it does not know how to handle, so it could not apply that initial-privilege record.

## When it happens

It is emitted at WARNING during `pg_dump --binary-upgrade` or extension handling when a `pg_init_privs` row refers to a catalog kind the code path does not recognize.

## Is this a problem?

This is an internal consistency notice about extension privilege bookkeeping, not a user command error. It typically surfaces during upgrades; capture the object identifiers in the message and the extensions installed, and report it if a dump or upgrade is affected. It rarely requires action beyond investigation.

## Example

*Illustrative* — an unhandled init-privs entry during a binary upgrade dump.

```text
WARNING:  unsupported pg_init_privs entry: 2611 16400 0
```

## Related

- [ACL array contains wrong data type](./acl-array-contains-wrong-data-type.md)
- [aclinsert is no longer supported](./aclinsert-is-no-longer-supported.md)
