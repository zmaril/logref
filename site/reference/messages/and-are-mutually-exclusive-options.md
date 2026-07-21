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
reproduced: true
---

# `%s and %s are mutually exclusive options`

## What it means

A command was given two options that cannot both be specified at once. The placeholders are the two conflicting option names. The command accepts either but not both together because they request incompatible behaviors.

## When it happens

Combining mutually exclusive clauses — for example two options of a `CREATE`/`ALTER SUBSCRIPTION` or a client tool that contradict each other in a single invocation.

## How to fix

Remove one of the two named options. Decide which behavior you actually want and specify only that one. The message names both options, so the fix is to drop whichever does not apply.

## Example

*Reproduced* — captured from `reproducers/scenarios/25_ddl_objects_more.sql`.

```sql
CREATE SUBSCRIPTION sub CONNECTION 'host=localhost' PUBLICATION p WITH (connect=false, slot_name=NONE, create_slot=true);
```

Produces:

```text
ERROR:  connect = false and create_slot = true are mutually exclusive options
```

## Related

- [and are incompatible options](./and-are-incompatible-options.md)
- [requires a parameter](./requires-a-parameter.md)
