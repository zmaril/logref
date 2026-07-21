---
message: "channel name too long"
slug: channel-name-too-long
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/async.c:919"
reproduced: false
---

# `channel name too long`

## What it means

A notification channel name exceeded the identifier length limit, which is 63 bytes by default. The channel name must fit within that limit, so a longer one is rejected.

## When it happens

It occurs on `LISTEN`, `NOTIFY`, or `UNLISTEN` when the channel name is longer than the maximum identifier length.

## How to fix

Shorten the channel name to the identifier limit or fewer bytes. Use a compact naming scheme for notification channels.

## Example

*Illustrative* — an over-long channel name.

```sql
NOTIFY a_very_long_channel_name_that_exceeds_the_identifier_length_limit;
-- ERROR:  channel name too long
```

## Related

- [channel name cannot be empty](./channel-name-cannot-be-empty.md)
- [character number must be positive](./character-number-must-be-positive.md)
