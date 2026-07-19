---
message: "Injection points are not supported by this build"
slug: injection-points-are-not-supported-by-this-build-f95f5e
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/misc/injection_point.c:395"
  - "postgres/src/backend/utils/misc/injection_point.c:523"
  - "postgres/src/backend/utils/misc/injection_point.c:540"
  - "postgres/src/backend/utils/misc/injection_point.c:557"
  - "postgres/src/backend/utils/misc/injection_point.c:570"
  - "postgres/src/backend/utils/misc/injection_point.c:616"
reproduced: false
---

# `Injection points are not supported by this build`

## What it means

An injection point (a testing hook that lets code pause or divert at named spots) was invoked, but this build was compiled without injection-point support (`--enable-injection-points`). Injection points are a test/development feature, off in normal builds.

## When it happens

Running a test or extension that attaches to or triggers an injection point against a standard release build. It only appears in testing scenarios; production builds do not enable the feature.

## How to fix

Only use injection points in a build configured with `--enable-injection-points` (typically a development or test build). Standard release builds intentionally omit them. If you are running the core regression/isolation tests that use injection points, build Postgres with the flag enabled; otherwise this feature is not meant for production use.

## Example

*Illustrative* — triggering an injection point on a normal build.

```sql
SELECT injection_points_attach('some-point', 'error');
```

Produces:

```text
ERROR:  Injection points are not supported by this build
```

## Related

- [this build does not support compression with %s](./this-build-does-not-support-compression-with.md)
- [ICU is not supported in this build](./icu-is-not-supported-in-this-build.md)
