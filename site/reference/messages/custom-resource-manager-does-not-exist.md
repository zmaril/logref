---
message: "custom resource manager \"%s\" does not exist"
slug: custom-resource-manager-does-not-exist
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_waldump/pg_waldump.c:1104"
reproduced: false
---

# `custom resource manager "%s" does not exist`

## What it means

`pg_waldump` was asked to filter by a custom resource manager name that it does not know. The placeholder is the name. Resource managers label the kinds of records in the WAL, and custom ones are registered by extensions.

## When it happens

It happens when you pass `--rmgr` to `pg_waldump` with the name of a custom resource manager that is not registered in the installation whose WAL you are reading.

## How to fix

Use a resource-manager name that exists. List the known managers with `pg_waldump --rmgr=list`, and make sure any extension that defines a custom manager is present. Correct the name and rerun.

## Example

*Illustrative* — an unknown custom resource manager.

```text
pg_waldump: error: custom resource manager "myext_rmgr" does not exist
```

## Related

- [custom resource manager ID is out of range](./custom-resource-manager-id-is-out-of-range.md)
- [custom resource manager name is invalid](./custom-resource-manager-name-is-invalid.md)
