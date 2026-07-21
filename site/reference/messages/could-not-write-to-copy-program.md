---
message: "could not write to COPY program: %m"
slug: could-not-write-to-copy-program
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/copyto.c:634"
reproduced: false
---

# `could not write to COPY program: %m`

## What it means

`COPY TO PROGRAM` could not write to the pipe feeding the external program. The trailing text is the operating-system error. `COPY TO PROGRAM` streams rows to a command's standard input.

## When it happens

It fires during `COPY ... TO PROGRAM '...'` when the write to the program's input fails — usually because the program exited early or closed its input before COPY finished.

## How to fix

Check the program you are piping to. If it exits before reading all the input, the write breaks with a pipe error. Make sure the command consumes its entire standard input and exits successfully. Test the command on its own, and look for its own error output.

## Example

*Illustrative* — the target program closed its input.

```sql
COPY t TO PROGRAM 'head -1 > /tmp/out';
-- ERROR:  could not write to COPY program: Broken pipe
```

## Related

- [could not write to COPY file](./could-not-write-to-copy-file.md)
- [could not write to shell backup program](./could-not-write-to-shell-backup-program.md)
