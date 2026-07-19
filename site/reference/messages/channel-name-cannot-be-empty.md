---
message: "channel name cannot be empty"
slug: channel-name-cannot-be-empty
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/async.c:913"
reproduced: false
---

# `channel name cannot be empty`

## What it means

A `LISTEN`, `NOTIFY`, or `UNLISTEN` command was given an empty channel name. Notification channels must be named, so an empty string is not accepted.

## When it happens

It occurs when a channel name resolves to an empty string, often from an unquoted empty identifier or a parameter that supplied no value.

## How to fix

Supply a non-empty channel name. Check the value that feeds the channel argument, and quote the identifier if it contains special characters.

## Example

*Illustrative* — an empty channel name.

```sql
NOTIFY "";
-- ERROR:  channel name cannot be empty
```

## Related

- [channel name too long](./channel-name-too-long.md)
- [character number must be positive](./character-number-must-be-positive.md)
