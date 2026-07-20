---
message: "%s is not yet supported in unquoted SQL function body"
slug: is-not-yet-supported-in-unquoted-sql-function-body
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/functioncmds.c:955"
  - "postgres/src/backend/commands/functioncmds.c:974"
reproduced: false
---

# `%s is not yet supported in unquoted SQL function body`

## What it means

A new-style SQL function or procedure body (written with `BEGIN ATOMIC ... END` rather than a quoted string) used a construct that this form does not yet support. The placeholder names the construct.

## When it happens

It arises in `CREATE FUNCTION ... BEGIN ATOMIC ... END` or `CREATE PROCEDURE` with a standard SQL body when it contains a statement or feature the unquoted body cannot represent in this version.

## How to fix

Rewrite the body using constructs the standard SQL body supports, or fall back to the classic quoted string body (`AS $$ ... $$`) which accepts a broader range. Consult the `CREATE FUNCTION` documentation for what the `BEGIN ATOMIC` form allows.

## Example

*Illustrative* — an unsupported construct in a standard SQL body.

```sql
CREATE FUNCTION f() RETURNS int BEGIN ATOMIC ... END;  -- construct not supported here
```

## Related

- [is already a member of extension](./is-already-a-member-of-extension.md)
- [invalid attribute in procedure definition](./invalid-attribute-in-procedure-definition.md)
