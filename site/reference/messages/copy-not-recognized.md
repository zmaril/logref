---
message: "COPY %s \"%s\" not recognized"
slug: copy-not-recognized
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/copy.c:498"
  - "postgres/src/backend/commands/copy.c:556"
reproduced: false
---

# `COPY %s "%s" not recognized`

## What it means

A `COPY` command included an option keyword it does not understand in that position. The placeholders are the option context and the unrecognized token. The parser found a word where a known `COPY` option or format keyword was expected.

## When it happens

Writing `COPY` with a misspelled or unsupported option, using an option not available in the running server version, or a syntax mismatch between the legacy and `WITH (...)` option forms.

## How to fix

Check the `COPY` syntax for the server version and correct the option name or placement. Prefer the `WITH (option value, ...)` form, and confirm the option exists in your Postgres release. The message names the token that was not recognized.

## Example

*Illustrative* — an unknown COPY option.

```sql
COPY t FROM STDIN (FORMAT wibble);
-- ERROR:  COPY format "wibble" not recognized
```

## Related

- [COPY delimiter character must not appear in the specification](./copy-delimiter-character-must-not-appear-in-the-specification.md)
- [COPY from stdin failed](./copy-from-stdin-failed.md)
