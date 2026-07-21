---
message: "unrecognized transfer mode"
slug: unrecognized-transfer-mode
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/controldata.c:709"
  - "postgres/src/bin/pg_upgrade/file.c:291"
reproduced: false
---

# `unrecognized transfer mode`

## What it means

Internal error in `pg_upgrade`. The transfer driver met a file-transfer mode value that is not one of the defined modes (copy, link, clone).

## When it happens

It fires when the internal transfer-mode selector holds a value outside the known set. A normal `pg_upgrade` invocation does not produce it.

## How to fix

This is a guard over `pg_upgrade`'s transfer selection. Use one of the documented modes (`--copy`, `--link`, `--clone`); if a standard invocation reaches it, capture the command and report it as a reproducible bug.

## Example

*Illustrative* — an unrecognized transfer mode.

```text
FATAL:  unrecognized transfer mode
```

## Related

- [unknown file type for "%s"](./unknown-file-type-for.md)
- [unrecognized checksum algorithm: "%s"](./unrecognized-checksum-algorithm.md)
