---
message: "subscription with %s must also set %s"
slug: subscription-with-must-also-set
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/subscriptioncmds.c:519"
  - "postgres/src/backend/commands/subscriptioncmds.c:535"
reproduced: false
---

# `subscription with %s must also set %s`

## What it means

A subscription option was set that requires another option to be set together with it. The placeholders name the two options. Certain subscription settings are only valid in combination.

## When it happens

It arises from `CREATE`/`ALTER SUBSCRIPTION` where one option depends on another — for example a setting that only makes sense when a companion option is also specified.

## How to fix

Set both options together as the message indicates, or remove the one that carries the dependency. Consult the subscription option documentation for which options must be combined.

## Example

*Illustrative* — a subscription option missing its required companion.

```text
ERROR:  subscription with slot_name = NONE must also set enabled = false, create_slot = false
```

## Related

- [%s options %s and %s cannot be used together](./options-and-cannot-be-used-together-72fe42.md)
- [subscription with OID %u does not exist](./subscription-with-oid-does-not-exist.md)
