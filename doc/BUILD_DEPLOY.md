# Pinnacle-Configuration Build and Deployment

## Purpose and scope

Pinnacle-Configuration is the Rust Cargo workspace for the on-device SoCcentric WebConfig daemon and configuration engine. It serves the embedded configuration UI, uses Rustls-based TLS, persists configuration, and integrates with systemd/update backends. The root Makefile is the authoritative entry point for host builds, tests, linting, cross builds, local runs, and release tarballs.

## 1. Prerequisites

- Linux/macOS host with `curl`, `make`, and network access for the first Rust toolchain setup.
- `rustup` and the exact toolchain in `rust-toolchain.toml`: Rust `1.97.1`, `rustfmt`, `clippy`, plus `x86_64-unknown-linux-gnu`, `aarch64-unknown-linux-gnu`, and `armv7-unknown-linux-gnueabihf` targets.
- A C/C++ build environment may be needed by transitive crates. Cross linking additionally requires suitable target linkers/sysroots.
- OpenSSL is not the application TLS implementation, but release packaging and deployment may use `openssl` for key material or checksums.

## 2. Setup

Install the pinned toolchain and targets:

```bash
make toolchain
```

This target can install rustup through `https://sh.rustup.rs` and downloads from Rust infrastructure. It is conditional on network access and changes the user Rust installation. Bare `make` only prints help.

## 3. Build and compile

Debug workspace build:

```bash
make build
```

Optimized release build using the repository's exact `opt-level=z`, LTO, single codegen unit, abort-on-panic, and symbol stripping profile:

```bash
make release
```

Cross-target parity build for all three declared targets:

```bash
make cross
```

This requires the cross targets and usable linkers/sysroots; it does not flash a device.

## 4. Test and lint

The workspace test target uses the fake sysroot paths where supported and does not require physical hardware:

```bash
make test
```

Run the quality gate:

```bash
make lint
make fmt                 # modifies Rust formatting
make check               # build, test, and lint
```

`lint` runs Clippy with `-D warnings` and `cargo fmt --check`. `check` is the Makefile's full validation alias.

## 5. Packaging and artifacts

Vendor the offline crate source tarball after dependency changes:

```bash
make vendor
```

Package the source and vendor tarballs used by the Yocto recipe and print SHA-256 checksums:

```bash
make release-artifacts
```

The target delegates to `tools/release-artifacts.sh` and requires a prior `make vendor`. Cargo debug/release outputs are under `target/`; release binaries are target-specific under `target/<triple>/release/`. No root Makefile package installer or Debian/RPM target exists.

## 6. Deployment, install, and run

Run against the real host sysroot and live `/proc`/`/sys`:

```bash
make run
```

This writes development state to `./data`, binds the exported `WEBCONFIG_PORT` (default `8443`), and can invoke real systemd/update backends. It is conditional and may have host side effects; use a disposable host or the target device.

Run the mock mode with a temporary fake sysroot and no hardware:

```bash
make run-mock
```

Override the port when needed:

```bash
WEBCONFIG_PORT=9443 make run-mock
```

Stop the process listening on the selected TCP port:

```bash
make stop
```

There is no root Makefile install target. Device installation must be supplied by the surrounding Yocto `meta-webconfig` recipe/image integration and must place the daemon, configuration, TLS material, and systemd unit according to the target image policy.

## 7. Cleanup

```bash
make clean                 # cargo clean; removes target/
```

`make clean` removes debug and release Cargo outputs. It does not remove the development `data/` directory or generated signing material.

## 8. Hardware, cloud, and manual verification caveats

- `make test` is intentionally fake-sysroot/host oriented; it cannot prove correct live `/proc`, `/sys`, systemd, update, TLS, or board behavior.
- `make run` uses real host backends and must not be treated as a harmless mock.
- Cross builds prove compilation only. Validate boot, service startup, TLS certificate enrollment, authentication, configuration persistence, update flow, and resource budgets on the supported i.MX target.
- `vendor` and `release-artifacts` are release-process operations; verify generated checksums and Yocto fetch paths before publishing.
- Any cloud, remote update, or production credential integration is outside this Makefile and requires manual environment-specific verification.
