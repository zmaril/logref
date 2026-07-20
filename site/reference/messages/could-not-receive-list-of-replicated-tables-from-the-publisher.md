---
message: "could not receive list of replicated tables from the publisher: %s"
slug: could-not-receive-list-of-replicated-tables-from-the-publisher
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONNECTION_FAILURE
    code: "08006"
call_sites:
  - "postgres/src/backend/commands/subscriptioncmds.c:3111"
  - "postgres/src/backend/commands/subscriptioncmds.c:3495"
reproduced: false
---

# `could not receive list of replicated tables from the publisher: %s`

## What it means

A subscriber could not fetch the set of tables covered by its publications from the publisher. The `%s` is the publisher's error. Without the table list the subscription cannot synchronize.

## When it happens

The publisher connection failed, the subscription role lacked rights, or the referenced publications were missing, during `CREATE SUBSCRIPTION` or a refresh.

## How to fix

Read the publisher error. Confirm the publisher is reachable, the connection role can read publication metadata, and the publications named in the subscription exist on the publisher.

## Example

*Illustrative* — the publisher rejected the table-list request.

```text
ERROR:  could not receive list of replicated tables from the publisher: ERROR:  publication "mypub" does not exist
```

## Related

- [could not obtain publication information](./could-not-obtain-publication-information.md)
- [could not identify system](./could-not-identify-system-got-rows-and-fields-expected-rows-and-or-more-fields.md)
