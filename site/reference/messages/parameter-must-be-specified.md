---
message: "parameter \"%s\" must be specified"
slug: parameter-must-be-specified
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/collationcmds.c:256"
  - "postgres/src/backend/commands/collationcmds.c:267"
  - "postgres/src/backend/commands/collationcmds.c:273"
  - "postgres/src/backend/commands/collationcmds.c:281"
reproduced: false
---

# `parameter "%s" must be specified`

## What it means

A required option was omitted from a command that demands it. The placeholder names the missing parameter. Some object definitions — collations, some extension options, and similar — have parameters with no default, so leaving one out is an error rather than a fallback.

## When it happens

Running a `CREATE`/`ALTER` (for example `CREATE COLLATION` without a required attribute, or an extension option block) that leaves out a parameter the command treats as mandatory.

## How to fix

Add the named parameter to the command. Consult the syntax for the object you are defining to see which options are required; for collations, supply the provider-specific fields the chosen provider needs.

## Example

*Illustrative* — a create statement missing a required parameter.

```sql
CREATE COLLATION c (provider = icu);  -- parameter "locale" must be specified
```

## Related

- [parameter requires a Boolean value](./parameter-requires-a-boolean-value.md)
- [cannot be specified unless locale provider is chosen](./cannot-be-specified-unless-locale-provider-is-chosen.md)
