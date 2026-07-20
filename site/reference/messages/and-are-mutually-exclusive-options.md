---
message: "%s and %s are mutually exclusive options"
slug: and-are-mutually-exclusive-options
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/subscriptioncmds.c:477"
  - "postgres/src/backend/commands/subscriptioncmds.c:485"
  - "postgres/src/backend/commands/subscriptioncmds.c:492"
  - "postgres/src/backend/commands/subscriptioncmds.c:513"
  - "postgres/src/backend/commands/subscriptioncmds.c:529"
reproduced: false
---

# `%s and %s are mutually exclusive options`

## What it means

A command was given two options that cannot both be specified at once. The placeholders are the two conflicting option names. The command accepts either but not both together because they request incompatible behaviors.

## When it happens

Combining mutually exclusive clauses — for example two options of a `CREATE`/`ALTER SUBSCRIPTION` or a client tool that contradict each other in a single invocation.

## How to fix

Remove one of the two named options. Decide which behavior you actually want and specify only that one. The message names both options, so the fix is to drop whichever does not apply.

## Example

*Illustrative* — two conflicting subscription options.

```sql
CREATE SUBSCRIPTION s CONNECTION '...' PUBLICATION p WITH (connect = false, enabled = true);
```

## Related

- [and are incompatible options](./and-are-incompatible-options.md)
- [requires a parameter](./requires-a-parameter.md)
