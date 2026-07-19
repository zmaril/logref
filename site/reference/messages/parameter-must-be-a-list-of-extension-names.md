---
message: "parameter \"%s\" must be a list of extension names"
slug: parameter-must-be-a-list-of-extension-names
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/postgres_fdw/option.c:460"
  - "postgres/src/backend/commands/extension.c:839"
  - "postgres/src/backend/commands/extension.c:854"
reproduced: false
---

# `parameter "%s" must be a list of extension names`

## What it means

A configuration parameter that expects a comma-separated list of extension names was given a value that is not in that form. The setting is parsed as a list of identifiers, and the supplied value did not parse as one.

## When it happens

Setting an option such as a foreign-data-wrapper's extensions list, or a server parameter that names extensions, to a value that is malformed — wrong separators, empty entries, or non-identifier text.

## How to fix

Provide a comma-separated list of valid extension names, for example `extensions 'hstore, pg_trgm'`. Remove stray characters and empty entries, and confirm each named extension is spelled as an installed extension.

## Example

*Illustrative* — a malformed extensions list.

```sql
ALTER SERVER s OPTIONS (SET extensions '???');  -- must be a list of extension names
```

## Related

- [invalid value for option](./invalid-value-for-option.md)
- [is not a member of extension](./is-not-a-member-of-extension.md)
