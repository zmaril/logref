---
message: "parameter \"%s\" requires a Boolean value"
slug: parameter-requires-a-boolean-value
passthrough: false
api: [ereport]
level: [ERROR]
level_runtime_chosen: true
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/extension.c:800"
  - "postgres/src/backend/commands/extension.c:808"
  - "postgres/src/backend/commands/extension.c:816"
  - "postgres/src/backend/utils/misc/guc.c:3039"
reproduced: true
---

# `parameter "%s" requires a Boolean value`

## What it means

A configuration or command option that expects a boolean was given a value that does not parse as one. The placeholder names the parameter. Boolean options accept `on`/`off`, `true`/`false`, `yes`/`no`, `1`/`0` (and unambiguous prefixes); anything else is rejected.

## When it happens

Setting a boolean GUC (`SET`, `postgresql.conf`, `ALTER SYSTEM`, or a per-object option like an extension or reloption) to a string such as `enabled`, `y`, or a number other than 0/1.

## How to fix

Use a recognized boolean literal — `on`, `off`, `true`, `false`, `yes`, `no`, `1`, or `0`. Quote it if the context needs a string. Check for a stray typo or an unquoted word where the option parser expected a boolean.

## Example

*Reproduced* — captured from `reproducers/scenarios/34_guc_vacuum_copy_xml.sql`.

```sql
SET row_security = maybe;
```

Produces:

```text
ERROR:  parameter "row_security" requires a Boolean value
```

## Related

- [parameter must be specified](./parameter-must-be-specified.md)
- [permission denied to set parameter](./permission-denied-to-set-parameter.md)
