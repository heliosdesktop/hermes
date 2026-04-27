# helios-hermes

Standalone build and release repository for prebuilt Hermes desktop runtime artifacts used by Helios.

The repository pins an upstream Hermes source release, builds desktop runtime artifacts in GitHub Actions, packages headers and libraries in a stable layout, and publishes archives through GitHub Releases.

## Initial Scope

- Hermes line: v1
- Hermes version: `250829098.0.12`
- Note: Hermes version is extracted from `https://github.com/facebook/react-native/blob/main/packages/react-native/sdks/hermes-engine/version.properties`
- Hermes source ref: `250829098.0.0-stable`, resolved to a commit SHA before download
- Build type: `Release`
- Targets:
  - `aarch64-apple-darwin`
  - `x86_64-apple-darwin`
  - `x86_64-pc-windows-msvc`
  - `aarch64-pc-windows-msvc` best-effort, depending on GitHub-hosted runner availability

Linux can be added later with the same packaging contract.

## Artifact Contract

Archives are named:

```txt
helios-hermes-{hermesVersion}-{target}-{buildType}.tar.gz
```

Each archive contains:

```txt
include/
  jsi/
  hermes/
lib/
  libhermes*.a, libjsi*.a, *.lib, *.dll, *.dylib, or *.so depending on target
metadata.json
```

`metadata.json` records the Hermes line, Hermes version, resolved source ref, target triple, build type, source URL, source archive SHA-256, packaged libraries, and library SHA-256 values. A sidecar `{archive}.sha256` file records the final archive SHA-256.

## Build Locally

The scripts currently require CMake 3.x for compatibility with Hermes' CMake files.

macOS:

```sh
HERMES_VERSION=250829098.0.12 HERMES_REF=250829098.0.0-stable TARGET=aarch64-apple-darwin BUILD_TYPE=Release ./scripts/build-hermes-unix.sh
```

Windows PowerShell:

```powershell
$env:HERMES_VERSION = "250829098.0.12"
$env:HERMES_REF = "250829098.0.0-stable"
$env:TARGET = "x86_64-pc-windows-msvc"
$env:BUILD_TYPE = "Release"
.\scripts\build-hermes-windows.ps1
```

Build output is written to `dist/`.

## Release Flow

Use the `Release Hermes Artifacts` workflow manually, or push a tag matching:

```txt
helios-hermes-250829098.0.12
```

The workflow builds all configured targets, downloads the resulting archives, creates or updates a GitHub Release, and uploads the `.tar.gz` archives plus `.sha256` sidecars.
