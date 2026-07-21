---
message: "could not get data directory using %s: %s"
slug: could-not-get-data-directory-using-34e6aa
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/option.c:478"
reproduced: false
---

# `could not get data directory using %s: %s`

## What it means

`pg_upgrade` queried a cluster for its data directory and the query returned an error string rather than a path. The `%s` values give the command and the server's error text. It needs the data directory to continue.

## When it happens

It happens during `pg_upgrade` startup while probing a cluster, when the server answers the data-directory query with an error — for example a connection or permission problem reported by the server.

## How to fix

Read the included server error text for the specific cause, then confirm the binary and data-directory options are correct and the account can connect to and read each cluster. Correct the underlying problem and rerun `pg_upgrade`.

## Example

*Illustrative* — the server reported an error for the query.

```text
pg_upgrade: fatal: could not get data directory using SHOW data_directory: permission denied
```

## Related

- [could not get data directory using](./could-not-get-data-directory-using-2a9020.md)
- [could not get server version](./could-not-get-server-version.md)
