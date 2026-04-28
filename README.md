# helios-hermes

A standalone repository that builds, packages, and releases prebuilt Hermes desktop runtime artifacts for use by Helios.

This repo pins a specific Hermes source release, builds desktop runtime artifacts (static libs, dynamic libs, headers) across multiple targets, packages them in a stable layout, and publishes archives with reproducible metadata and checksums.

This repository's purpose is to produce and distribute packaged Hermes runtime artifacts so consumers (like Helios) can depend on a stable archive rather than building Hermes themselves for each platform. The build is driven by pinned Hermes source (version + ref) and produces a single archive per (version, target, build-type) containing headers, libraries, and metadata.

Supported versions and targets

- Hermes line: v1 (this repo is scoped to Hermes v1 style artifacts)
- Default Hermes version: `250829098.0.12`
  - The Hermes version here is synchronized from React Native's `version.properties` upstream.
- Default resolved source ref: `250829098.0.0-stable` (resolved to a specific commit SHA during packaging)
- Build type: `Release` (configurable)
- Primary targets:
  - `aarch64-apple-darwin` (Apple Silicon macOS)
  - `x86_64-apple-darwin` (Intel macOS)
  - `x86_64-pc-windows-msvc` (Windows x86_64)
  - `aarch64-pc-windows-msvc` (Windows ARM64, best-effort depending on runner availability)
- Linux targets can be added later following the same packaging contract.

Artifact contract

Archive name format:
helios-hermes-{hermesVersion}-{target}-{buildType}.tar.gz

Inside each archive:

- include/
  - jsi/
  - hermes/
- lib/
  - platform-specific library files: `libhermes*.a`, `libjsi*.a`, `*.lib`, `*.dll`, `*.dylib`, or `*.so` depending on target
