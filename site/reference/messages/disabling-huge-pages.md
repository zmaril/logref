---
message: "disabling huge pages"
slug: disabling-huge-pages
passthrough: false
api: [ereport]
level: [DEBUG1]
call_sites:
  - "postgres/src/backend/port/win32_shmem.c:245"
  - "postgres/src/backend/port/win32_shmem.c:250"
reproduced: false
---

# `disabling huge pages`

## What it means

A debug trace line that the server is proceeding without huge pages, having fallen back from a huge-page shared-memory allocation.

## When it happens

It appears at high debug levels when `huge_pages = try` and the huge-page allocation could not be satisfied, so the server uses ordinary pages instead.

## Is this a problem?

No action is needed with `huge_pages = try` — the fallback is intended. To require huge pages, set `huge_pages = on` (the server then fails to start if they are unavailable) and configure the operating system's huge-page pool accordingly.

## Example

*Illustrative* — falling back from huge pages.

```text
DEBUG:  disabling huge pages
```

## Related

- [could not resize shared memory segment "%s" to %zu bytes: %m](./could-not-resize-shared-memory-segment-to-bytes.md)
- [no usable system locales were found](./no-usable-system-locales-were-found.md)
