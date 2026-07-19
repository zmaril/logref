---
message: "cannot use different values of publish_generated_columns for table \"%s.%s\" in different publications"
slug: cannot-use-different-values-of-publish-generated-columns-for-table-in-different
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/replication/pgoutput/pgoutput.c:1112"
reproduced: false
---

# `cannot use different values of publish_generated_columns for table "%s.%s" in different publications`

## What it means

A table belongs to several publications that a subscription reads, and those publications set different `publish_generated_columns` values for it. The subscription cannot reconcile the conflicting choices, so it refuses the combination.

## When it happens

It occurs when a subscription combines publications where one publishes a table's generated columns and another does not, for the same table.

## How to fix

Make `publish_generated_columns` agree across the publications that include the table, or split the table across subscriptions so each sees a single consistent setting.

## Example

*Illustrative* — conflicting generated-column publishing.

```text
ERROR:  cannot use different values of publish_generated_columns for table "public.t" in different publications
```

## Related

- [cannot use publication WHERE clause for relation](./cannot-use-publication-where-clause-for-relation.md)
- [cannot use system column in publication column list](./cannot-use-system-column-in-publication-column-list.md)
