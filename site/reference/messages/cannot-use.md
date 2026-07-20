---
message: "Cannot use \"%s\": %s"
slug: cannot-use
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/pgcrypto/pgcrypto.c:511"
reproduced: false
---

# `Cannot use "%s": %s`

## What it means

A configuration or parameter value was rejected. The first placeholder is the value or name that was supplied, and the second gives the reason. This is a generic message used where a supplied value fails a validity check with an explanation attached.

## When it happens

It occurs when a command, function, or setting receives a value that passes basic parsing but fails a semantic check, and the code reports both the value and why it was refused.

## How to fix

Read the reason in the second half of the message and supply a value that satisfies it. Correct the offending option or argument named in the first half and rerun.

## Example

*Illustrative* — a rejected value with a reason.

```text
ERROR:  Cannot use "foo": not a valid choice
```

## Related

- [cannot use custom wait event string longer than characters](./cannot-use-custom-wait-event-string-longer-than-characters.md)
- [cannot use special role specifier in DROP ROLE](./cannot-use-special-role-specifier-in-drop-role.md)
