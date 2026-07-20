---
message: "currtid cannot handle this view"
slug: currtid-cannot-handle-this-view
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/tid.c:436"
reproduced: false
---

# `currtid cannot handle this view`

## What it means

The internal `currtid` routine, which maps a row's location through a view, could not handle the view it was given. This is an internal path once used by some interfaces to locate the latest version of a row.

## When it happens

It fires when `currtid` is invoked on a view whose definition it cannot resolve to a single underlying table with a physical row location. It is not part of ordinary query execution.

## How to fix

This is an internal guard reached only through the legacy `currtid` interface. Work with the underlying table directly rather than the view. If an application relies on this path, it is depending on deprecated behavior; capture the view definition and the calling code if you need to report it.

## Example

*Illustrative* — a view currtid cannot resolve.

```text
ERROR:  currtid cannot handle this view
```

## Related

- [currtid cannot handle views with no CTID](./currtid-cannot-handle-views-with-no-ctid.md)
- [ctid isn't of type TID](./ctid-isn-t-of-type-tid.md)
