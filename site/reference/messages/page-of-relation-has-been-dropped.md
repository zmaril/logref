---
message: "page %u of relation %s has been dropped"
slug: page-of-relation-has-been-dropped
passthrough: false
api: [elog]
level: [DEBUG2]
call_sites:
  - "postgres/src/backend/access/transam/xlogutils.c:182"
  - "postgres/src/backend/access/transam/xlogutils.c:210"
reproduced: false
---

# `page %u of relation %s has been dropped`

## What it means

A debug trace line that a buffer for a page of a relation is being discarded because the underlying relation (or that page) has been dropped or truncated.

## When it happens

It appears at high debug levels when the buffer manager drops buffers for a relation that was removed or shortened, as part of normal cleanup.

## Is this a problem?

No action is needed. Dropping buffers for a removed or truncated relation is normal buffer-manager behavior. The message is visible only at raised debug levels.

## Example

*Illustrative* — dropping a page of a removed relation.

```text
DEBUG:  page 5 of relation base/16401/12345 has been dropped
```

## Related

- [cleaning up dynamic shared memory control segment with ID %u](./cleaning-up-dynamic-shared-memory-control-segment-with-id.md)
- [checkpoint record is at %X/%08X](./checkpoint-record-is-at.md)
