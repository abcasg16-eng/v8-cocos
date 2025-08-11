#!/bin/bash

set -e

# Check if the number of arguments is 1
if [ $# -ne 1 ]; then
    echo "Usage: $0 <architecture>"
    exit 1
fi

# Get the value of the first argument
ARCH="$1"

# Check if the argument value is "arm64", "arm", "x86" or "x64"
if [ "${ARCH}" != "arm64" && "${ARCH}" != "x64"]; then
    echo "Architecture must be 'arm64'"
    exit 1
fi

# If there is 1 argument and its value is "arm64" or "x64", continue with the rest of the script
echo "Valid architecture: ${ARCH}"

OH_SDK_NATIVE_PATH=${HOME}/openharmony/command-line-tools/sdk/default/openharmony/native

ls -l ${OH_SDK_NATIVE_PATH}

ARGS="target_os=\"linux\"
target_cpu=\"${ARCH}\"
v8_target_cpu=\"${ARCH}\"
is_clang=true
enable_dsyms=false
use_thin_lto=false
use_lld=true
use_gold=false
use_glib=false
target_sysroot=\"${OH_SDK_NATIVE_PATH}/sysroot\"
clang_base_path=\"${OH_SDK_NATIVE_PATH}/llvm\"
clang_use_chrome_plugins=false
chrome_pgo_phase=0
is_component_build=false
v8_monolithic=true
use_custom_libcxx=false
use_custom_libcxx_for_host=false
is_debug=false
v8_use_external_startup_data=false
is_official_build=true
v8_enable_i18n_support=false
treat_warnings_as_errors=false
symbol_level=0
v8_enable_webassembly=true
use_cxx17=true
v8_enable_fuzztest=false
v8_enable_sandbox=false"

FINAL_ARGS=${ARGS}

echo "FINAL_ARGS:${FINAL_ARGS}"

gn gen out/oh --args="${FINAL_ARGS}"

ninja -C out/oh v8_monolith -v
