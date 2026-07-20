---
message: "invalid option name \"%s\": must not contain \"=\""
slug: invalid-option-name-must-not-contain
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/access/common/reloptions.c:1402"
  - "postgres/src/backend/commands/foreigncmds.c:84"
reproduced: false
---

# `invalid option name "%s": must not contain "="`

## What it means

An option name supplied in an option list contained an `=` character, which is forbidden because `=` separates the name from its value. The name is therefore invalid.

## When it happens

It arises when passing generic options — for example to foreign-data-wrapper objects, `CREATE SERVER`/`USER MAPPING`, or other `OPTIONS (...)` clauses — where an option key itself includes an equals sign.

## How to fix

Remove the `=` from the option name. Write options as `name 'value'` pairs; if a value contains `=` that is fine, but the key must not. Check for a mistyped option list where the name and value ran together.

## Example

*Illustrative* — an option name containing '='.

```sql
OPTIONS ( "a=b" 'c' )  -- name must not contain '='
```

## Related

- [option missing](./option-missing.md)
- [invalid character in extension schema must not contain any of](./invalid-character-in-extension-schema-must-not-contain-any-of.md)
