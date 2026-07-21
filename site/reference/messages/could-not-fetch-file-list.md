---
message: "could not fetch file list: %s"
slug: could-not-fetch-file-list
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_rewind/libpq_source.c:270"
reproduced: false
---

# `could not fetch file list: %s`

## What it means

`pg_rewind` could not read the list of files from the source server it is rewinding against. The `%s` gives the reason. Without the file list it cannot plan the rewind.

## When it happens

It happens early in a `pg_rewind` run using a live source connection when the query for the source's file list fails — a lost connection or an unexpected server error.

## How to fix

Check connectivity to the source server and its log for the failing query. Confirm the connecting role has the privileges `pg_rewind` needs, then rerun.

## Example

*Illustrative* — the source file-list query failing.

```text
pg_rewind: fatal: could not fetch file list: ...reason...
```

## Related

- [could not fetch remote file](./could-not-fetch-remote-file.md)
- [could not find common ancestor of the source and target cluster's timelines](./could-not-find-common-ancestor-of-the-source-and-target-cluster-s-timelines.md)
