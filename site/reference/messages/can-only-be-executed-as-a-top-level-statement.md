---
message: "%s can only be executed as a top-level statement"
slug: can-only-be-executed-as-a-top-level-statement
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/wait.c:54"
reproduced: false
---

# `%s can only be executed as a top-level statement`

## What it means

A command that must run on its own was embedded inside a function, procedure, or multi-statement context. The placeholder is the command. Some commands cannot run inside another statement's execution.

## When it happens

It occurs when a command with this restriction is placed inside a PL function body, a `DO` block, or another statement rather than being issued directly by the client.

## How to fix

Run the command as a standalone top-level statement from the client, outside any function or block. Restructure the logic so the restricted command is executed on its own rather than nested.

## Example

*Illustrative* — a top-level-only command nested in a block.

```sql
DO $$ BEGIN VACUUM; END $$;
```

## Related

- [calling procedures with output arguments is not supported in sql functions](./calling-procedures-with-output-arguments-is-not-supported-in-sql-functions.md)
- [can only be called in an event trigger function](./can-only-be-called-in-an-event-trigger-function.md)
