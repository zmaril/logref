---
message: "could not write to shell backup program: %m"
slug: could-not-write-to-shell-backup-program
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/contrib/basebackup_to_shell/basebackup_to_shell.c:300"
reproduced: false
---

# `could not write to shell backup program: %m`

## What it means

The `basebackup_to_shell` extension could not write backup data to the shell command's input. The trailing text is the operating-system error. The extension pipes a base backup to a configured command.

## When it happens

It fires while streaming a base backup to the shell target when the write to the program's input fails — usually because the command exited before consuming all the data.

## How to fix

Check the shell command configured for `basebackup_to_shell`. It must read its entire standard input and exit successfully; a command that quits early breaks the pipe. Test the command independently and inspect its own error output.

## Example

*Illustrative* — the backup program closed its input.

```text
ERROR:  could not write to shell backup program: Broken pipe
```

## Related

- [could not write to COPY program](./could-not-write-to-copy-program.md)
- [could not write server file](./could-not-write-server-file.md)
