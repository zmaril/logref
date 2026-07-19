---
message: "permission denied to change owner of foreign-data wrapper \"%s\""
slug: permission-denied-to-change-owner-of-foreign-data-wrapper
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/src/backend/commands/foreigncmds.c:230"
  - "postgres/src/backend/commands/foreigncmds.c:238"
reproduced: false
---

# `permission denied to change owner of foreign-data wrapper "%s"`

## What it means

A role tried to reassign ownership of a foreign-data wrapper and was refused. The placeholder is the wrapper name. Changing a foreign-data wrapper's owner is a superuser-only operation.

## When it happens

It arises from `ALTER FOREIGN DATA WRAPPER ... OWNER TO` run by a non-superuser, or when the new owner is not permitted.

## How to fix

Perform the change as a superuser. Foreign-data wrappers can encode access to external systems, so their ownership is deliberately restricted to superusers; delegate the operation to one.

## Example

*Illustrative* — a non-superuser reassigning a foreign-data wrapper.

```text
ERROR:  permission denied to change owner of foreign-data wrapper "myfdw"
```

## Related

- [permission denied to set the "%s" option of a file_fdw foreign table](./permission-denied-to-set-the-option-of-a-file-fdw-foreign-table.md)
- [subscription owner "%s" does not have permission on foreign server "%s"](./subscription-owner-does-not-have-permission-on-foreign-server.md)
