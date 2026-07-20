---
message: "aborting because of server version mismatch"
slug: aborting-because-of-server-version-mismatch
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_dump/connectdb.c:222"
  - "postgres/src/bin/pg_dump/pg_backup_db.c:52"
reproduced: false
---

# `aborting because of server version mismatch`

## What it means

A client tool stopped because the server's version is not compatible with what the tool requires. Some tools refuse to operate against a server older or newer than they support, to avoid producing incorrect results.

## When it happens

Running pg_dump, pg_dumpall, or a related tool against a server whose version falls outside the tool's supported range — commonly a newer server dumped with an older client binary.

## How to fix

Use a tool version compatible with the server. For dumps, run a client at least as new as the server, since newer servers may use features an older dump program cannot represent. Install the matching client package or point at the newer binaries.

## Example

*Illustrative* — an incompatible client and server.

```text
pg_dump: error: aborting because of server version mismatch
```

## Related

- [invalid restrict key](./invalid-restrict-key.md)
- [option requires option](./option-requires-option.md)
