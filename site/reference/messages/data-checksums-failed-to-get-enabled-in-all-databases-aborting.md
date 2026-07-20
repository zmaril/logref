---
message: "data checksums failed to get enabled in all databases, aborting"
slug: data-checksums-failed-to-get-enabled-in-all-databases-aborting
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_RESOURCES
    code: "53000"
call_sites:
  - "postgres/src/backend/postmaster/datachecksum_state.c:1317"
reproduced: false
---

# `data checksums failed to get enabled in all databases, aborting`

## What it means

The online checksum-enabling process could not turn checksums on in every database and gave up. Enabling checksums while the server runs works database by database, and one or more did not complete. The server reports it as insufficient resources.

## When it happens

It happens during an in-place checksum enable when a database cannot be processed — often because it could not be connected to, or the worker was interrupted or ran out of a needed resource.

## How to fix

Look at the server log for which database failed and why. Common causes are a database that does not allow connections or a worker that was interrupted. Resolve the specific database's problem and restart the enable operation, which resumes the remaining work.

## Example

*Illustrative* — the online enable did not finish.

```text
ERROR:  data checksums failed to get enabled in all databases, aborting
```

## Related

- [data checksums are not enabled in cluster](./data-checksums-are-not-enabled-in-cluster.md)
- [database is not currently accepting connections](./database-is-not-currently-accepting-connections.md)
