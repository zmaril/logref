---
message: "could not obtain subscription OID: %s"
slug: could-not-obtain-subscription-oid
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:2072"
reproduced: false
---

# `could not obtain subscription OID: %s`

## What it means

`pg_createsubscriber` queried a server for a subscription's OID and the query failed. The `%s` value gives the reason. It uses the OID to manage the subscription during setup.

## When it happens

It happens during subscriber setup when the OID query fails — usually a connection problem, a subscription that does not exist, or missing privileges.

## How to fix

Confirm the named subscription exists on the target and the connection role can query it, then rerun. The included reason usually names the cause.

## Example

*Illustrative* — the subscription OID query failed.

```text
pg_createsubscriber: error: could not obtain subscription OID: connection to server failed
```

## Related

- [could not obtain subscription OID: got rows, expected row](./could-not-obtain-subscription-oid-got-rows-expected-row.md)
- [could not obtain pre-existing subscriptions](./could-not-obtain-pre-existing-subscriptions.md)
