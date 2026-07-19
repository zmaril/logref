---
message: "permission denied to examine \"%s\""
slug: permission-denied-to-examine
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/src/backend/utils/misc/guc.c:4267"
  - "postgres/src/backend/utils/misc/guc.c:4315"
  - "postgres/src/backend/utils/misc/guc.c:5352"
reproduced: false
---

# `permission denied to examine "%s"`

## What it means

A role tried to inspect a configuration parameter or object whose value it is not allowed to see. Some settings and objects are restricted so that only privileged roles can read them.

## When it happens

Reading a restricted configuration parameter (for example a setting flagged as superuser-only) or examining an object through a function that enforces a privilege check the current role does not pass.

## How to fix

Read the value as a role permitted to examine it, or grant the role the privilege the parameter requires. Some parameters can be exposed to non-superusers by granting the relevant role membership; consult the parameter's documentation for what controls its visibility.

## Example

*Illustrative* — reading a restricted setting.

```sql
SHOW some_restricted_setting;  -- permission denied to examine
```

## Related

- [permission denied](./permission-denied.md)
- [invalid value for option](./invalid-value-for-option.md)
