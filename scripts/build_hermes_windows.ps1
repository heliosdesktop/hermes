$ErrorActionPreference = "Stop"

$build_type = if (($env:BUILD_TYPE ?? "").ToLower() -eq "release") {
    "Release"
} else {
    "Debug"
}

switch ($env:MSVC_ARCH) {
    "x64"   { $cmakeArch = "x64" }
    "arm64" { $cmakeArch = "ARM64" }
    default { throw "Unknown MSVC_ARCH: $env:MSVC_ARCH" }
}

$cmakeArgs = @(
    "-S", "hermes",
    "-B", "build",
    "-G", "Visual Studio 17 2022",
    "-A", $cmakeArch,
    "-DCMAKE_BUILD_TYPE=$build_type"
)

if ($env:MSVC_ARCH -eq "arm64") {
    $cmakeArgs += "-DHERMES_ALLOW_BOOST_CONTEXT=0"
}

cmake @cmakeArgs
cmake --build build --config $build_type --parallel
