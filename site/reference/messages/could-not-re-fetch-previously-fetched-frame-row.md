---
message: "could not re-fetch previously fetched frame row"
slug: could-not-re-fetch-previously-fetched-frame-row
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeWindowAgg.c:863"
reproduced: false
---

# `could not re-fetch previously fetched frame row`

## What it means

A window function tried to re-read a row from its frame that it had already read once and could not retrieve it again. Window functions buffer frame rows so they can revisit them, and this re-read came back empty.

## When it happens

It fires while executing a window function that revisits earlier frame rows, when a previously fetched row cannot be fetched again — an internal invariant, not a normal user condition.

## How to fix

This is an internal guard. It should not be reachable in normal use; it can follow a resource problem in the window buffer or an internal inconsistency. If it recurs on a specific query, capture the query and report a reproducible case.

## Example

*Illustrative* — a frame row could not be re-fetched.

```text
ERROR:  could not re-fetch previously fetched frame row
```

## Related

- [could not overwrite high key in half-dead page](./could-not-overwrite-high-key-in-half-dead-page.md)
- [could not read from file set: read only of bytes](./could-not-read-from-file-set-read-only-of-bytes.md)
