---
message: "invalid character in extension \"%s\" schema: must not contain any of \"%s\""
slug: invalid-character-in-extension-schema-must-not-contain-any-of
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TEXT_REPRESENTATION
    code: "22P02"
call_sites:
  - "postgres/src/backend/commands/extension.c:1442"
  - "postgres/src/backend/commands/extension.c:1469"
reproduced: false
---

# `invalid character in extension "%s" schema: must not contain any of "%s"`

## What it means

The schema name given for an extension contains a character that Postgres forbids in this context. The second placeholder lists the disallowed characters (such as quotes or backslashes) that were found.

## When it happens

It arises from `CREATE EXTENSION ... SCHEMA name` or `ALTER EXTENSION ... SET SCHEMA name` when the target schema name includes characters that would break the extension's internal script substitution.

## How to fix

Use a schema name without the forbidden characters. Stick to ordinary identifier characters; avoid embedded quotes, backslashes, and the other characters named in the message. Rename the schema if necessary and retry.

## Example

*Illustrative* — a schema name with a forbidden character.

```sql
CREATE EXTENSION hstore SCHEMA "we'ird";  -- rejected
```

## Related

- [is already a member of extension](./is-already-a-member-of-extension.md)
- [invalid option name must not contain](./invalid-option-name-must-not-contain.md)
