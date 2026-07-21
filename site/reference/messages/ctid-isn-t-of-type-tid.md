---
message: "ctid isn't of type TID"
slug: ctid-isn-t-of-type-tid
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/adt/tid.c:382"
reproduced: false
---

# `ctid isn't of type TID`

## What it means

Code that works with a row's physical location expected a `tid` value and got a different type. `ctid` is the system column that names a tuple's on-disk position, and it must be of type `tid`. The server reports this as an unsupported case.

## When it happens

It fires in low-level operations that resolve a `ctid` — for example some current-of or tuple-location paths — when the value handed in is not a real `tid`, typically from an unusual query shape over a view or non-standard relation.

## How to fix

This usually surfaces from applying a `ctid`-based operation to something that does not have a normal physical `ctid`, such as certain views. Operate on the underlying table directly, or avoid relying on `ctid` for that object. If you reach it through ordinary table access, capture the query and report it.

## Example

*Illustrative* — a non-tid ctid value.

```text
ERROR:  ctid isn't of type TID
```

## Related

- [currtid cannot handle views with no CTID](./currtid-cannot-handle-views-with-no-ctid.md)
- [currtid cannot handle this view](./currtid-cannot-handle-this-view.md)
