---
message: "option \"%s\" missing"
slug: option-missing
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/replication/pgoutput/pgoutput.c:425"
  - "postgres/src/backend/replication/pgoutput/pgoutput.c:429"
reproduced: false
---

# `option "%s" missing`

## What it means

A required option was not present in an option list. The placeholder names the missing option. Some object definitions require specific options to be set.

## When it happens

It arises from `OPTIONS (...)` clauses on foreign-data-wrapper objects (servers, foreign tables, user mappings) or extension objects when a mandatory option is omitted.

## How to fix

Add the required option named in the message with an appropriate value. Check the foreign-data wrapper's or extension's documentation for its mandatory options, and include all of them in the `OPTIONS` list.

## Example

*Illustrative* — a required option left out.

```sql
CREATE FOREIGN TABLE ft (...) SERVER s;  -- required option missing
```

## Related

- [invalid option name must not contain](./invalid-option-name-must-not-contain.md)
- [invalid value for boolean option](./invalid-value-for-boolean-option.md)
