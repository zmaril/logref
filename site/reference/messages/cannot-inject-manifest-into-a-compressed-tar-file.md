---
message: "cannot inject manifest into a compressed tar file"
slug: cannot-inject-manifest-into-a-compressed-tar-file
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:1102"
reproduced: false
---

# `cannot inject manifest into a compressed tar file`

## What it means

`pg_basebackup` was asked to add the backup manifest to a tar output that is compressed. The tool can only inject the manifest into an uncompressed tar stream, so a compressed target is rejected.

## When it happens

It occurs when `pg_basebackup` runs in tar format with compression enabled and also needs to write the manifest into the archive.

## How to fix

Write the manifest as a separate file (the default), or produce an uncompressed tar and compress it afterwards, or use plain format. Check the `--format`, `--compress`, and manifest options together so they are compatible.

## Example

*Illustrative* — manifest injection into a compressed tar.

```text
pg_basebackup: error: cannot inject manifest into a compressed tar file
```

## Related

- [cannot generate a manifest because no manifest is available for the final input backup](./cannot-generate-a-manifest-because-no-manifest-is-available-for-the-final-input.md)
- [cannot get raw page from relation](./cannot-get-raw-page-from-relation.md)
