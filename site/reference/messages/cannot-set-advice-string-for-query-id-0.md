---
message: "cannot set advice string for query ID 0"
slug: cannot-set-advice-string-for-query-id-0
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/pg_stash_advice/stashfuncs.c:293"
reproduced: false
---

# `cannot set advice string for query ID 0`

## What it means

The `pg_stash_advice` extension was asked to set an advice string for query id 0. A query id of 0 means query-id computation is off or the statement was not fingerprinted, so there is no query to attach advice to.

## When it happens

It occurs when a stash-advice function runs while `compute_query_id` is disabled, or before the current statement has a computed query id.

## How to fix

Enable query-id computation by setting `compute_query_id` to `on` (or `auto` with a consumer active), and attach advice only when a non-zero query id is available. Confirm the target statement has been fingerprinted first.

## Example

*Illustrative* — setting advice for query id 0.

```text
ERROR:  cannot set advice string for query ID 0
```

## Related

- [cannot set option for enabled subscription](./cannot-set-option-for-enabled-subscription.md)
- [cannot set parameters during a parallel operation](./cannot-set-parameters-during-a-parallel-operation.md)
