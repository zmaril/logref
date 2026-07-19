---
message: "could not get size for full pathname of datadir %s: error code %lu"
slug: could-not-get-size-for-full-pathname-of-datadir-error-code
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/port/win32_shmem.c:74"
reproduced: false
---

# `could not get size for full pathname of datadir %s: error code %lu`

## What it means

On Windows, the server asked the operating system how long the expanded data-directory path would be and the call failed. The `%lu` value is the Windows error code. It needs the length before expanding the path for the shared-memory name.

## When it happens

It fires during startup on Windows while preparing shared memory, when `GetFullPathName` fails when queried for the path length — usually an invalid or inaccessible data-directory path.

## How to fix

Check that the data-directory path is valid and reachable and that the service account can read it. Look up the reported Windows error code for the specific cause, correct the path, and start the server again.

## Example

*Illustrative* — the data-directory path length could not be determined.

```text
FATAL:  could not get size for full pathname of datadir C:\pgdata: error code 3
```

## Related

- [could not generate full pathname for datadir error code](./could-not-generate-full-pathname-for-datadir-error-code.md)
- [could not get current working directory](./could-not-get-current-working-directory.md)
