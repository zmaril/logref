---
message: "invalid value for parameter \"%s\": \"%s\""
slug: invalid-value-for-parameter-821f2c
passthrough: false
api: [ereport, pg_log_error]
level: [ERROR, FATAL]
level_runtime_chosen: true
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/tcop/backend_startup.c:799"
  - "postgres/src/backend/utils/misc/guc.c:3059"
  - "postgres/src/backend/utils/misc/guc.c:3100"
  - "postgres/src/backend/utils/misc/guc.c:3184"
  - "postgres/src/backend/utils/misc/guc.c:4608"
  - "postgres/src/common/percentrepl.c:79"
  - "postgres/src/common/percentrepl.c:83"
  - "postgres/src/common/percentrepl.c:118"
  - "postgres/src/common/percentrepl.c:122"
reproduced: false
---

# `invalid value for parameter "%s": "%s"`

## What it means

A configuration parameter or option was set to a string value it does not accept. The first placeholder is the parameter name, the second the rejected value. This form (a string value) covers GUCs and startup parameters with enumerated or specially formatted values.

## When it happens

`SET`/`ALTER SYSTEM`/`postgresql.conf` assigning a bad value to a parameter — an unknown keyword for an enum GUC, a malformed list, or a startup parameter the client sent with an invalid value. It can be `FATAL` when it happens at connection startup.

## How to fix

Use a value the parameter accepts; the message names the parameter. For enum GUCs, check the documentation or `pg_settings.enumvals` for the allowed keywords. For list-valued parameters, verify the syntax. Correct the value in the config or the `SET` statement and reload/reconnect.

## Example

*Illustrative* — a bad enum value for a GUC.

```sql
SET log_statement = 'sometimes';
```

Produces:

```text
ERROR:  invalid value for parameter "log_statement": "sometimes"
HINT:  Available values: none, ddl, mod, all.
```

## Related

- [invalid value for parameter](./invalid-value-for-parameter-61fc7e.md)
- [parameter cannot be changed without restarting the server](./parameter-cannot-be-changed-without-restarting-the-server.md)
