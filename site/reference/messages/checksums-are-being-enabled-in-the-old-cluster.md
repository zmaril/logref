---
message: "checksums are being enabled in the old cluster"
slug: checksums-are-being-enabled-in-the-old-cluster
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/controldata.c:662"
reproduced: false
---

# `checksums are being enabled in the old cluster`

## What it means

`pg_upgrade` found that the old cluster is in the middle of enabling data-page checksums. An upgrade cannot proceed while a checksum-enable operation is still running, because the cluster is not in a consistent, ready state.

## When it happens

It occurs when `pg_upgrade` runs against an old cluster where `pg_enable_data_checksums()` or the offline checksum tool has not finished.

## How to fix

Let the checksum operation complete on the old cluster and confirm checksums are fully enabled, then run `pg_upgrade` again. Do not upgrade while the checksum state is still changing.

## Example

*Illustrative* — upgrading during checksum enablement.

```text
pg_upgrade: fatal: checksums are being enabled in the old cluster
```

## Related

- [cluster is not compatible with this version of pg_checksums](./cluster-is-not-compatible-with-this-version-of-pg-checksums.md)
- [cluster must be shut down](./cluster-must-be-shut-down.md)
