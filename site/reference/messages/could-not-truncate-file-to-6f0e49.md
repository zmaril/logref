---
message: "could not truncate file \"%s\" to %lld: %m"
slug: could-not-truncate-file-to-6f0e49
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/heap/rewriteheap.c:1105"
reproduced: false
---

# `could not truncate file "%s" to %lld: %m`

## What it means

The heap-rewrite code could not truncate a file to a given length. The placeholders are the file and the length, and the trailing text is the operating-system error. Rewriting a heap (for example during `VACUUM FULL` or `CLUSTER`) can trim the new file.

## When it happens

It fires while the server rewrites a table's storage and needs to shorten the new relation file, when the truncate fails.

## How to fix

Read the OS error. An I/O failure points at the storage under the data directory; a full or read-only filesystem can also produce it. Check the disk holding the relation and rerun the operation once the storage problem is resolved.

## Example

*Illustrative* — a heap-rewrite truncate failed.

```text
ERROR:  could not truncate file "base/16384/98765" to 40960: Input/output error
```

## Related

- [could not truncate file to (pg_rewind)](./could-not-truncate-file-to-244e28.md)
- [could not truncate file to blocks](./could-not-truncate-file-to-blocks.md)
