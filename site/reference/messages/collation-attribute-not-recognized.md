---
message: "collation attribute \"%s\" not recognized"
slug: collation-attribute-not-recognized
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/collationcmds.c:113"
reproduced: true
---

# `collation attribute "%s" not recognized`

## What it means

A `CREATE COLLATION` used an ICU locale attribute the server does not recognize. The named attribute is not a valid key in the locale specification, so the definition is rejected.

## When it happens

It occurs on `CREATE COLLATION ... (locale = '...')` with an ICU locale string that contains an unknown attribute keyword.

## How to fix

Correct the locale string to use recognized ICU attributes. Check the ICU locale syntax and keyword names, and fix the misspelled or unsupported attribute.

## Example

*Reproduced* — captured from `reproducers/scenarios/21_ddl_objects.sql`.

```sql
CREATE COLLATION repro.c2 (nonexistent_param = 'x');
```

Produces:

```text
ERROR:  collation attribute "nonexistent_param" not recognized
```

## Related

- [collation already exists in schema](./collation-already-exists-in-schema.md)
- [collation default cannot be copied](./collation-default-cannot-be-copied.md)
