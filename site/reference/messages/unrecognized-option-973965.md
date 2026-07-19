---
message: "unrecognized option: %s"
slug: unrecognized-option-973965
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/extension.c:2221"
  - "postgres/src/backend/commands/extension.c:3561"
  - "postgres/src/backend/replication/walsender.c:1247"
  - "postgres/src/backend/replication/walsender.c:1507"
reproduced: false
---

# `unrecognized option: %s`

## What it means

Internal error. Extension-support code encountered an option keyword it does not handle while processing an extension control or command option. The placeholder is the option text. This particular site treats an unknown option as a `can't happen` case, distinct from the user-facing `unrecognized parameter` errors.

## When it happens

It surfaces from a specific extension code path. It generally reflects an internal mismatch or a malformed control structure rather than a plain user typo, which is reported with a clearer message elsewhere.

## How to fix

Check the extension's control and SQL scripts for a malformed option if you maintain the extension; otherwise treat it as an internal bug and report it with the extension name and version. Capture the command that triggered it.

## Example

*Illustrative* — emitted internally by extension handling.

```text
ERROR:  unrecognized option: badopt
```

## Related

- [unrecognized compression algorithm](./unrecognized-compression-algorithm.md)
- [parameter must be specified](./parameter-must-be-specified.md)
