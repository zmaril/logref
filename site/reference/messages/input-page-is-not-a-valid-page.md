---
message: "input page is not a valid %s page"
slug: input-page-is-not-a-valid-page
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/pageinspect/brinfuncs.c:63"
  - "postgres/contrib/pageinspect/brinfuncs.c:103"
  - "postgres/contrib/pageinspect/btreefuncs.c:769"
  - "postgres/contrib/pageinspect/gistfuncs.c:54"
  - "postgres/contrib/pageinspect/gistfuncs.c:63"
  - "postgres/contrib/pageinspect/hashfuncs.c:70"
  - "postgres/contrib/pageinspect/hashfuncs.c:79"
reproduced: true
---

# `input page is not a valid %s page`

## What it means

A `pageinspect` function was handed a byte string that is not a valid page of the expected kind. The placeholder is the page type (heap, btree, etc.). The function validates the page header before interpreting it and rejects malformed input.

## When it happens

Passing the wrong `get_raw_page` output to a type-specific function (for example feeding a heap page to a btree function), an out-of-range block number, or genuinely corrupted page bytes. It is common when debugging with the wrong function for the relation's access method.

## How to fix

Use the `pageinspect` function that matches the relation's type and read a valid block. Confirm the block number is within the relation's size and that you passed the right `get_raw_page(relation, blkno)` output to the matching function. If the page is genuinely corrupt, that itself is the finding — investigate the relation's integrity.

## Example

*Reproduced* — captured from `reproducers/scenarios/64_contrib_inspect_deep.sql`.

```sql
SELECT brin_revmap_data(get_raw_page('repro.big_pkey', 0));
```

Produces:

```text
ERROR:  input page is not a valid BRIN page
```

## Related

- [must be superuser to use raw page functions](./must-be-superuser-to-use-raw-page-functions.md)
- [invalid block number](./invalid-block-number-d8b3d3.md)
