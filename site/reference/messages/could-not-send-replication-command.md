---
message: "could not send replication command \"%s\": %s"
slug: could-not-send-replication-command
passthrough: false
api: [pg_fatal, pg_log_error]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:1838"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:1996"
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:282"
  - "postgres/src/bin/pg_basebackup/receivelog.c:542"
  - "postgres/src/bin/pg_basebackup/receivelog.c:588"
  - "postgres/src/bin/pg_basebackup/streamutil.c:296"
  - "postgres/src/bin/pg_basebackup/streamutil.c:370"
  - "postgres/src/bin/pg_basebackup/streamutil.c:422"
  - "postgres/src/bin/pg_basebackup/streamutil.c:511"
  - "postgres/src/bin/pg_basebackup/streamutil.c:672"
  - "postgres/src/bin/pg_basebackup/streamutil.c:717"
reproduced: false
---

# `could not send replication command "%s": %s`

## What it means

A replication client failed to send a command over the replication protocol connection. The first placeholder is the command, the second the server's error text. The physical or logical replication connection could not carry the request.

## When it happens

`pg_basebackup`, `pg_receivewal`, `pg_recvlogical`, or a standby's walreceiver sending commands like `IDENTIFY_SYSTEM`, `START_REPLICATION`, or `CREATE_REPLICATION_SLOT` when the connection drops, the server rejects the command, or authentication for replication is insufficient.

## How to fix

Read the server error text. Common causes: the connecting role lacks the `REPLICATION` attribute, `pg_hba.conf` has no `replication` entry for the client, `max_wal_senders` is exhausted, or the network dropped. Grant replication rights, add the `replication` HBA line, ensure enough wal senders, and verify connectivity.

## Example

*Illustrative* — a role without replication rights.

```text
pg_receivewal: error: could not send replication command "IDENTIFY_SYSTEM": ERROR:  must be superuser or replication role to start walsender
```

## Related

- [recovery is in progress](./recovery-is-in-progress.md)
- [could not read from input file: %m](./could-not-read-from-input-file-c5612a.md)
