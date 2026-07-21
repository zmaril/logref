---
message: "currtid cannot handle views with no CTID"
slug: currtid-cannot-handle-views-with-no-ctid
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/adt/tid.c:390"
reproduced: false
---

# `currtid cannot handle views with no CTID`

## What it means

The internal `currtid` routine was applied to a view that exposes no underlying `ctid`, so there is no physical row location to work with. The server reports this as an unsupported case.

## When it happens

It fires when the legacy `currtid` path runs against a view whose columns do not carry a `ctid` from a single base table — for example a view over a join or an aggregate.

## How to fix

Operate on the base table directly, where a physical `ctid` exists, rather than through such a view. This path is deprecated; if an application depends on it, target the underlying table instead.

## Example

*Illustrative* — a view with no underlying ctid.

```text
ERROR:  currtid cannot handle views with no CTID
```

## Related

- [currtid cannot handle this view](./currtid-cannot-handle-this-view.md)
- [ctid isn't of type TID](./ctid-isn-t-of-type-tid.md)
