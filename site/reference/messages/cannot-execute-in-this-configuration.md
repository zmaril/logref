---
message: "cannot execute %s in this configuration"
slug: cannot-execute-in-this-configuration
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/repack.c:905"
reproduced: false
---

# `cannot execute %s in this configuration`

## What it means

A `REPACK` command was blocked because the current server configuration does not permit it. The named command needs a capability or setting that this build or runtime state does not offer. The placeholder is the command name.

## When it happens

It occurs when `REPACK` is run on a server whose configuration disallows the operation, such as a build or setting that lacks the required support.

## How to fix

Check the configuration prerequisites for the command in the documentation and enable the required setting, or run the command on a server built with the needed support. Review the accompanying detail message for the specific requirement.

## Example

*Illustrative* — a command blocked by configuration.

```text
ERROR:  cannot execute REPACK in this configuration
```

## Related

- [cannot execute on a shared catalog](./cannot-execute-on-a-shared-catalog.md)
- [cannot execute on multiple tables](./cannot-execute-on-multiple-tables.md)
