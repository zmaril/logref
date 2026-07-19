---
message: "cannot retrieve commit timestamp for transaction %u"
slug: cannot-retrieve-commit-timestamp-for-transaction
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/access/transam/commit_ts.c:294"
reproduced: false
---

# `cannot retrieve commit timestamp for transaction %u`

## What it means

A request for a transaction's commit timestamp could not be answered. Commit timestamps are recorded only when `track_commit_timestamp` is enabled, and the value for the requested transaction was not available. The placeholder is the transaction id.

## When it happens

It occurs when `pg_xact_commit_timestamp()` or related monitoring asks for a commit timestamp that was never recorded — because tracking was off when the transaction committed, or the record has since been truncated.

## How to fix

Enable `track_commit_timestamp` (a restart-required setting) so future commits record timestamps. Note that timestamps are unavailable for transactions that committed before tracking was on, and for very old transactions whose records were removed.

## Example

*Illustrative* — a missing commit timestamp.

```text
ERROR:  cannot retrieve commit timestamp for transaction 574839
```

## Related

- [cannot read past end of generated WAL: requested current position](./cannot-read-past-end-of-generated-wal-requested-current-position.md)
- [cannot setup replication origin when one is already setup](./cannot-setup-replication-origin-when-one-is-already-setup.md)
