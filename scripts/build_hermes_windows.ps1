$ErrorActionPreference = "Stop"

$build_type = if (($env:BUILD_TYPE ?? "").ToLower() -eq "release") {
    "Release"
} else {
    "Debug"
}

$build_folder = if ($build_type -eq "Release") {
    "build-release"
} else {
    "build"
}

switch ($env:MSVC_ARCH) {
    "x64"   { $targetTriple = "x86_64-pc-windows-msvc" }
    "arm64" { $targetTriple = "aarch64-pc-windows-msvc" }
    default { throw "Unknown MSVC_ARCH: $env:MSVC_ARCH" }
}

$cmakeArgs = @(
    "-S", "hermes",
    "-B", $build_folder,
    "-G", "Ninja",
    "-DCMAKE_C_COMPILER_TARGET=$targetTriple",
    "-DCMAKE_CXX_COMPILER_TARGET=$targetTriple",
    "-DCMAKE_SYSTEM_NAME=Windows",
    "-DCMAKE_C_COMPILER=clang-cl",
    "-DCMAKE_CXX_COMPILER=clang-cl",
    "-DCMAKE_BUILD_TYPE=$build_type",
    "-DHERMES_ALLOW_BOOST_CONTEXT=0",
    "-DCMAKE_CXX_FLAGS=/D_WINDOWS /D_HAS_EXCEPTIONS=1 /GR",
    "-DCMAKE_CXX_FLAGS_DEBUG=/Zi /Ob0 /Od /RTC1 /EHsc",
    "-DCMAKE_CXX_FLAGS_RELEASE=/O2 /Ob2 /DNDEBUG /EHsc",
    "-DCMAKE_EXE_LINKER_FLAGS=winmm.lib"
)

cmake @cmakeArgs

$buildTargets = @(
    "hermesvm_a",
    "jsi",
    "hermesapi",
    "hermesPublic",
    "hermesc",
    "hermescompiler",
    "hermes",
    "hvm",
    "hbcdump",
    "hbc-diff",
    "hbc-deltaprep",
    "hbc-attribute",
    "dependency-extractor",
    "hermesParser",
    "compileJS"
)

cmake --build $build_folder --target @buildTargets
