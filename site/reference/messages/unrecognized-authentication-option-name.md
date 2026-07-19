---
message: "unrecognized authentication option name: \"%s\""
slug: unrecognized-authentication-option-name
passthrough: false
api: [ereport]
level: [WARNING]
level_runtime_chosen: true
sqlstate:
  - symbol: ERRCODE_CONFIG_FILE_ERROR
    code: "F0000"
call_sites:
  - "postgres/src/backend/libpq/auth-oauth.c:1068"
  - "postgres/src/backend/libpq/hba.c:2320"
reproduced: false
---

# `unrecognized authentication option name: "%s"`

## What it means

An entry in the host-based authentication file (`pg_hba.conf`) used an option name the server does not know, so that option could not be applied to the authentication method.

## When it happens

It is emitted at WARNING while parsing `pg_hba.conf` when a method's option field contains a misspelled or unsupported key (for example a typo in an LDAP, RADIUS, or cert option).

## Is this a problem?

Check the option spelling against the documentation for the authentication method in that line. Fix the key in `pg_hba.conf`, reload the configuration, and confirm the line now parses. An unrecognized option means that authentication rule is not being applied as intended.

## Example

*Illustrative* — a misspelled HBA option.

```text
WARNING:  unrecognized authentication option name: "ldapservr"
```

## Related

- [setting not supported by this build](./setting-not-supported-by-this-build.md)
- [unrecognized configuration parameter](./unrecognized-configuration-parameter.md)
