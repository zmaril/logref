---
message: "could not enable user right \"%s\": error code %lu"
slug: could-not-enable-user-right-error-code
passthrough: false
api: [ereport]
level: [varies]
level_runtime_chosen: true
call_sites:
  - "postgres/src/backend/port/win32_shmem.c:145"
  - "postgres/src/backend/port/win32_shmem.c:160"
  - "postgres/src/backend/port/win32_shmem.c:172"
  - "postgres/src/backend/port/win32_shmem.c:188"
reproduced: false
---

# `could not enable user right "%s": error code %lu`

## What it means

On Windows, the server or a tool failed to enable a required user right (privilege) in its process token. The placeholders are the right's name and the OS error code. Certain operations — locking pages in memory, acting as part of the operating system — require the account to hold and enable a specific Windows privilege.

## When it happens

Running on Windows where the service account lacks the named user right, or the right is present but could not be enabled in the token — commonly with settings that need `SeLockMemoryPrivilege` (large pages) or similar.

## Is this a problem?

Grant the named user right to the account the server runs as, using the Windows Local Security Policy (`secpol.msc`) or group policy, then restart the service. Decode the error code with the Windows error reference if the right is present but still cannot be enabled. If you do not need the feature that requires it (for example large pages), disabling that feature avoids the requirement.

## Example

*Illustrative* — a missing Windows user right.

```text
could not enable user right "SeLockMemoryPrivilege": error code 1300
```

## Related

- [could not create shared memory segment: error code](./could-not-create-shared-memory-segment-error-code.md)
- [failed to release reserved memory region addr error code](./failed-to-release-reserved-memory-region-addr-error-code.md)
