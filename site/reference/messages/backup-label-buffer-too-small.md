---
message: "backup label buffer too small"
slug: backup-label-buffer-too-small
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_rewind/pg_rewind.c:1005"
reproduced: false
---

# `backup label buffer too small`

## What it means

The buffer allocated to hold the backup label content was not large enough for the label the server generated. The backup label records the metadata a restore needs, and it did not fit the fixed buffer.

## When it happens

It is an internal size check in the backup machinery. It would only appear if a path name or label field grew beyond the expected bound.

## How to fix

This is not a routine user condition. If it appears, note the tablespace and data-directory paths in use, since unusually long paths are the likely trigger, and report it with the server version so the bound can be examined.

## Example

*Illustrative* — the label size guard.

```text
FATAL:  backup label buffer too small
```

## Related

- [backup label too long max bytes](./backup-label-too-long-max-bytes.md)
- [backup label contains data inconsistent with control file](./backup-label-contains-data-inconsistent-with-control-file.md)
