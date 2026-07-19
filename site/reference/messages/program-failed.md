---
message: "program \"%s\" failed"
slug: program-failed
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_EXTERNAL_ROUTINE_EXCEPTION
    code: "38000"
call_sites:
  - "postgres/src/backend/commands/copyfrom.c:1990"
  - "postgres/src/backend/commands/copyto.c:735"
reproduced: false
---

# `program "%s" failed`

## What it means

An external program invoked by the server (for example a `COPY ... FROM/TO PROGRAM`, or an archive/restore command) exited with a failure status. The placeholder is the program string. The command relaying data through that program could not complete.

## When it happens

It arises when `COPY` with `PROGRAM`, or a similar external-command mechanism, runs a shell command that returns a non-zero exit code, is killed by a signal, or cannot be executed.

## How to fix

Run the same command manually as the OS user the server runs as to see its actual error. Check the path, permissions, and that the program handles the data stream correctly. `COPY ... PROGRAM` requires superuser or the appropriate role; confirm that too.

## Example

*Illustrative* — a COPY PROGRAM whose command failed.

```text
ERROR:  program "gzip > /backups/out.gz" failed
```

## Related

- [unexpected default marker in COPY data](./unexpected-default-marker-in-copy-data.md)
- [tar member has unsafe path name: "%s"](./tar-member-has-unsafe-path-name.md)
