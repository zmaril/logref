---
message: "could not generate full pathname for datadir %s: error code %lu"
slug: could-not-generate-full-pathname-for-datadir-error-code
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/port/win32_shmem.c:84"
reproduced: false
---

# `could not generate full pathname for datadir %s: error code %lu`

## What it means

On Windows, the server asked the operating system to expand the data directory to a full path and the call failed. The `%lu` value is the Windows error code. The full path is needed to name the shared-memory segment.

## When it happens

It fires during startup on Windows while setting up shared memory, when `GetFullPathName` fails for the data-directory path — usually an invalid, too-long, or inaccessible path.

## How to fix

Check that the data-directory path is valid, reachable, and within Windows path-length limits, and that the service account can read it. Look up the reported Windows error code for the specific cause, correct the path, and start the server again.

## Example

*Illustrative* — the data-directory path could not be expanded.

```text
FATAL:  could not generate full pathname for datadir C:\pgdata: error code 3
```

## Related

- [could not get size for full pathname of datadir error code](./could-not-get-size-for-full-pathname-of-datadir-error-code.md)
- [could not get current working directory](./could-not-get-current-working-directory.md)
