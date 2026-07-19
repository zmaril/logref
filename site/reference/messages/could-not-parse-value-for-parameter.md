---
message: "could not parse value \"%s\" for parameter \"%s\""
slug: could-not-parse-value-for-parameter
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/test_decoding/test_decoding.c:192"
  - "postgres/contrib/test_decoding/test_decoding.c:202"
  - "postgres/contrib/test_decoding/test_decoding.c:214"
  - "postgres/contrib/test_decoding/test_decoding.c:228"
  - "postgres/contrib/test_decoding/test_decoding.c:239"
  - "postgres/contrib/test_decoding/test_decoding.c:250"
  - "postgres/contrib/test_decoding/test_decoding.c:260"
reproduced: false
---

# `could not parse value "%s" for parameter "%s"`

## What it means

An option value could not be parsed into the expected form. The first placeholder is the value, the second the parameter name. This form appears in output plugins and extensions (such as `test_decoding`) that validate their options at startup.

## When it happens

Passing a malformed value to a logical-decoding output plugin option or an extension parameter — for example a non-boolean where a boolean is expected, or a value that does not match the option's grammar.

## How to fix

Provide a value in the format the parameter expects; the message names both. For boolean options use `on`/`off` or `true`/`false`; for others consult the plugin/extension documentation. Correct the option in the replication slot's start command or the extension's configuration.

## Example

*Illustrative* — a bad boolean for a decoding option.

```sql
SELECT * FROM pg_logical_slot_get_changes('s', NULL, NULL, 'include-xids', 'maybe');
```

Produces:

```text
ERROR:  could not parse value "maybe" for parameter "include-xids"
```

## Related

- [invalid value for parameter](./invalid-value-for-parameter-821f2c.md)
- [option not recognized](./option-not-recognized.md)
