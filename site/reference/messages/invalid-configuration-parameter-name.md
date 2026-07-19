---
message: "invalid configuration parameter name \"%s\""
slug: invalid-configuration-parameter-name
passthrough: false
api: [ereport]
level: [varies]
level_runtime_chosen: true
sqlstate:
  - symbol: ERRCODE_INVALID_NAME
    code: "42602"
call_sites:
  - "postgres/src/backend/utils/misc/guc.c:1016"
  - "postgres/src/backend/utils/misc/guc.c:1032"
reproduced: false
---

# `invalid configuration parameter name "%s"`

## What it means

A configuration parameter was referenced by a name that is not a valid setting name, so it could not be resolved.

## When it happens

It arises from `SET`/`SHOW`, `ALTER SYSTEM`, `postgresql.conf`, and custom-parameter handling when the parameter name is misspelled or, for a namespaced custom parameter, malformed.

## Is this a problem?

Check the parameter name against `pg_settings` (or the documentation). For a custom (extension) parameter, use the `class.name` form with a valid class prefix. Fix the spelling and retry.

## Example

*Illustrative* — an unknown parameter name.

```text
ERROR:  invalid configuration parameter name "word_mem"
```

## Related

- [could not validate "%s" object: invalid attribute number %d found](./could-not-validate-object-invalid-attribute-number-found.md)
- [missing entry at end of line](./missing-entry-at-end-of-line.md)
