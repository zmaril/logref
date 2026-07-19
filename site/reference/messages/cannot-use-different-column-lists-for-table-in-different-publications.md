---
message: "cannot use different column lists for table \"%s.%s\" in different publications"
slug: cannot-use-different-column-lists-for-table-in-different-publications
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/subscriptioncmds.c:3523"
  - "postgres/src/backend/replication/logical/tablesync.c:849"
  - "postgres/src/backend/replication/pgoutput/pgoutput.c:1189"
reproduced: false
---

# `cannot use different column lists for table "%s.%s" in different publications`

## What it means

A single subscription drew from multiple publications that each publish the same table with a different column list. The placeholders name the schema and table. The subscriber cannot reconcile conflicting column lists for one table across the publications it subscribes to, so the combination is rejected.

## When it happens

Creating or altering a subscription to a set of publications where the same table appears with column lists that are not identical — for example one publication exposing `(a, b)` and another exposing `(a, c)` for the same table.

## How to fix

Make the column lists agree: publish the table with the same column list in every publication the subscription uses, or split the conflicting publications across separate subscriptions. If you need different columns, use distinct subscriptions rather than combining the publications.

## Example

*Illustrative* — conflicting column lists across publications.

```text
ERROR:  cannot use different column lists for table "public.t" in different publications
```

## Related

- [publication does not exist](./publication-does-not-exist.md)
- [cache lookup failed for publication table](./cache-lookup-failed-for-publication-table.md)
