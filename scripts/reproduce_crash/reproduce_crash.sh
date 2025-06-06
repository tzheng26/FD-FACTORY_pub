# !/bin/bash

# Reproduce crash
# Usage: bash reproduce_crash.sh <fuzz_driver> <crash_file>
# E.g.,: bash reproduce_crash.sh fuzz_driver.py fuzz_driver-oom-d5c0c1f9e9f39d0e7d020e160ffcf6f2a40094fc


# Check whether both fuzz driver and crash file are specified in command-line arguments
if [ $# -ne 2 ]; then
  echo "Usage: bash reproduce_crash.sh <fuzz_driver> <crash_file>"
  exit 1
fi

fuzz_driver=$1
crash_file=$2

# Check if the specified fuzz driver exists
if [ ! -f $fuzz_driver ]; then
  echo "The specified fuzz driver does not exist."
  exit 1
fi

# Check if the specified crash file exists
if [ ! -f $crash_file ]; then
  echo "The specified crash file does not exist."
  exit 1
fi

# Check if running in Docker
if grep -qE '/docker|/lxc' /proc/1/cgroup; then
  echo "Executing in a Docker container."
else
  echo "For security reasons, please use a Docker container when running LLM-generated fuzz drivers."
  exit 1
fi


# Run the specified fuzz driver with the crash file
# ------------------------------------------------------
# ASAN_OPTIONS:
# Ignore ODR violation: ASAN_OPTIONS=detect_odr_violation=0
# Avoid 'symbolizer buffer too small' warning: ASAN_OPTIONS=symbolize=0
# Ignore Python memory leaks: ASAN_OPTIONS=detect_leaks=0
# ------------------------------------------------------
# Atheris parameters:
# -timeout: the maximum time to run a single test case
# -rss_limit_mb: the maximum memory usage in MB
LD_PRELOAD=$(python3 -c 'import atheris; print(atheris.path())')/asan_with_fuzzer.so \
ASAN_OPTIONS=detect_odr_violation=0:symbolize=0:detect_leaks=0 \
python3 $fuzz_driver $crash_file \
        -timeout=60 \
        -rss_limit_mb=8192
