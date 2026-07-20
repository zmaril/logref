---
message: "could not find common ancestor of the source and target cluster's timelines"
slug: could-not-find-common-ancestor-of-the-source-and-target-cluster-s-timelines
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_rewind/pg_rewind.c:964"
reproduced: false
---

# `could not find common ancestor of the source and target cluster's timelines`

## What it means

`pg_rewind` compared the source and target clusters' timeline histories and found no shared point of divergence. Without a common ancestor it cannot compute what to rewind.

## When it happens

It happens when the two clusters were not derived from the same original cluster — for example pointing `pg_rewind` at two independently initialized clusters, or a target whose history does not connect to the source's.

## How to fix

Confirm the source and target genuinely share history (one was promoted from or forked off the other). `pg_rewind` only works on clusters with a common timeline ancestor; two unrelated clusters cannot be rewound onto each other.

## Example

*Illustrative* — two clusters with no shared timeline.

```text
pg_rewind: fatal: could not find common ancestor of the source and target cluster's timelines
```

## Related

- [could not find previous WAL record at](./could-not-find-previous-wal-record-at-93eda7.md)
- [could not fetch file list](./could-not-fetch-file-list.md)
