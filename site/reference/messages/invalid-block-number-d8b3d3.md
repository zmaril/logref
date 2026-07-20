---
message: "invalid block number"
slug: invalid-block-number-d8b3d3
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/pageinspect/hashfuncs.c:436"
  - "postgres/contrib/pageinspect/rawpage.c:56"
  - "postgres/contrib/pageinspect/rawpage.c:111"
  - "postgres/contrib/pageinspect/rawpage.c:351"
  - "postgres/contrib/pg_freespacemap/pg_freespacemap.c:45"
  - "postgres/contrib/pg_visibility/pg_visibility.c:101"
  - "postgres/contrib/pg_visibility/pg_visibility.c:142"
reproduced: false
---

# `invalid block number`

## What it means

A function was given a block (page) number outside the valid range for a relation. Block numbers are 0-based page indexes; a value that is negative, or at/beyond the relation's current page count, does not name a real page and is rejected.

## When it happens

Inspection functions (`pageinspect`, `pg_visibility`, `pg_freespacemap`, `pageinspect`'s `get_raw_page`) called with a block number past the end of the relation, or a negative value. Common when iterating pages without checking the relation's size first.

## How to fix

Query the relation's page count first — `pg_relation_size(rel) / current_setting('block_size')::int`, or `pg_relpages(rel)` from `pgstattuple`/`pageinspect` — and stay within `0 .. npages-1`. For empty relations there are no valid block numbers. Bound your loop to the current size.

## Example

*Illustrative* — inspecting a block past the end.

```sql
SELECT * FROM page_header(get_raw_page('t', 99999));
```

Produces:

```text
ERROR:  invalid block number 99999
```

## Related

- [input page is not a valid %s page](./input-page-is-not-a-valid-page.md)
- [must be superuser to use raw page functions](./must-be-superuser-to-use-raw-page-functions.md)
