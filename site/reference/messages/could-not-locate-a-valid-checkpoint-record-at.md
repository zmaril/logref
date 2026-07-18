---
message: "could not locate a valid checkpoint record at %X/%08X"
slug: could-not-locate-a-valid-checkpoint-record-at
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/access/transam/xlogrecovery.c:739"
reproduced: false
---

# `could not locate a valid checkpoint record at %X/%08X`

**Severity:** FATAL

## What it means

During startup recovery Postgres could not find a usable checkpoint record at the expected WAL location, so it cannot determine where to begin replaying WAL. Without a valid checkpoint the server has no safe starting point and refuses to come up. The placeholder is the WAL LSN it looked at. This is a `FATAL` with no SQLSTATE — it is an operational failure, not a SQL-level one.

## When it happens

Typically after a crash or an improper copy where WAL or the control file is missing, truncated, or inconsistent — for example a file-level backup taken without the proper start/stop backup procedure, a lost `pg_wal` segment, or storage corruption. It can also follow a botched point-in-time restore.

## How to fix

Do not run `pg_resetwal` reflexively — it discards WAL and can leave the database inconsistent; treat it as a last resort after taking a physical copy of the data directory. First investigate: confirm `pg_wal` and its segments are intact and that the `pg_control` file matches, and check storage for corruption. If you have a good base backup and archived WAL, restoring and replaying them is the safe path. Because data loss is on the table here, copy the whole data directory before attempting any repair, and consult the recovery documentation for your version.

## Example

*Illustrative* — starting a cluster whose WAL/control state is damaged; there is no SQL that safely reproduces this.

```text
pg_ctl start -D /var/lib/postgresql/data
```

Produces:

```text
FATAL:  could not locate a valid checkpoint record at 0/16D8A20
```

## Source

Emitted from [`postgres/src/backend/access/transam/xlogrecovery.c:739`](https://github.com/postgres/postgres/blob/master/src/backend/access/transam/xlogrecovery.c#L739).

## Related

- [database system is ready to accept connections](./database-system-is-ready-to-accept-connections.md)
