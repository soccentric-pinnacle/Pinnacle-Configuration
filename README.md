# Pinnacle-Configuration

## Project Summary

Pinnacle-Configuration is an on-device configuration service for the Pinnacle Yocto and embedded-Linux platform.

The Rust workspace contains `webconfig-engine` and `webconfigd`:

- The engine owns the configuration store, schema and board-manifest loading, validation, system appliers, alerts, monitoring, and rollback state.
- `webconfigd` is an Axum HTTP daemon using a current-thread Tokio runtime, rustls TLS, authentication, CSRF protection, section APIs, and server-sent events.
- The `frontend` directory is a build-free vanilla JavaScript UI that renders forms from JSON schemas.

Board data is separated from executable code in `board-manifests/pinnacle.json`, with `generic.yaml` as fallback. `schemas` contains application schemas.

`meta-webconfig` packages the daemon, static assets, schemas, manifest, and hardened service into a Yocto layer. API, schema-format, and board-manifest documentation accompany a production-readiness plan.

The Makefile defines debug and release builds, fake-sysroot tests, linting, formatting, vendoring, cross-target builds, and a temporary development run. `rust-toolchain.toml` pins the toolchain and the release profile targets a small stripped binary.

Real and mock backends include RAUC and zbus integration boundaries, but source evidence does not prove operation on a physical board or production identity deployment.

The fake-sysroot harness is the meaningful automated boundary. Cross-compilation and offline vendoring are configured rather than independently verified here.

Treat schema coverage, board manifests, certificates, and backend availability as deployment inputs.

## Feature Status

| # | Name / Description | Implemented? | Test Coverage? | Manual Test |
|---:|---|---|---|---|
| 1 | Rust configuration engine and JSON-backed store | Yes | Engine tests are wired through `make test` | [ ] Manual verification required |
| 2 | Schema-driven validation and vanilla-JS forms | Yes | Schema and HTTP integration coverage; browser coverage is limited | [ ] Manual verification required |
| 3 | TLS HTTP daemon with authenticated, CSRF-protected APIs | Yes | Fake-sysroot HTTP tests; production identity is not exercised | [ ] Manual verification required |
| 4 | Network commit/confirm rollback safety net | Yes | Automated harness exists; target reconnect and timeout need validation | [ ] Manual verification required |
| 5 | Board manifests and generic fallback | Yes | Manifest/schema files exist; all boards are not verified | [ ] Manual verification required |
| 6 | Yocto packaging and cross-target definitions | Partial | Makefile and layer recipes exist; image integration is unverified | [ ] Manual verification required |
| 7 | Alerts, monitoring, logs, services, updates, and I/O | Partial | Code and schemas exist; backend availability varies | [ ] Manual verification required |

## Tests and Commands

```bash
make build
make test
make lint
make cross
```

## Limitations

- Automated tests run without hardware.
- Real zbus/RAUC services, board schemas, TLS certificates, and rollback behavior require deployment validation.
