---
message: "end of tuple reached without looking at all its data"
slug: end-of-tuple-reached-without-looking-at-all-its-data
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATA_CORRUPTED
    code: "XX001"
call_sites:
  - "postgres/contrib/pageinspect/heapfuncs.c:411"
reproduced: true
---

# `end of tuple reached without looking at all its data`

## What it means

The `pageinspect` extension's heap-tuple decoder reached the end of a tuple before consuming all the bytes it expected. The placeholder context is a specific tuple. It signals a malformed or corrupt on-disk tuple.

## When it happens

It fires from `pageinspect` functions (such as `heap_page_items` with attribute decoding) when a tuple's data does not line up with its declared attribute layout, indicating heap corruption.

## How to fix

The tuple is inconsistent with the table's structure — likely corruption. Investigate storage health, and cross-check with `amcheck`/`pg_amcheck`. If the affected rows can be identified, consider dumping the salvageable data and rebuilding the table. Back up before intervening.

## Example

*Reproduced* — captured from `reproducers/scenarios/42_contrib_inspection.sql`.

```sql
SELECT tuple_data_split('repro.parent'::regclass, '\x00'::bytea, 0, 0, NULL);
```

Produces:

```text
ERROR:  end of tuple reached without looking at all its data
```

## Related

- [ending block number must be between 0 and](./ending-block-number-must-be-between-0-and.md)
- [encountered tuple with HEAP_MOVED considered current](./encountered-tuple-with-heap-moved-considered-current.md)
