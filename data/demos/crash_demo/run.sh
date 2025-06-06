# !/bin/bash

# Check if running in Docker
if grep -qE '/docker|/lxc' /proc/1/cgroup; then
  echo "The specified fuzz driver will be executed in a Docker container."
else
  echo "For security reasons, please use a Docker container when running LLM-generated fuzz drivers."
  exit 1
fi

# Run the specified fuzz driver
# ------------------------------------------------------
# ASAN_OPTIONS:
# Ignore ODR violation: ASAN_OPTIONS=detect_odr_violation=0
# Avoid 'symbolizer buffer too small' warning: ASAN_OPTIONS=symbolize=0
# Ignore Python memory leaks: ASAN_OPTIONS=detect_leaks=0
# ------------------------------------------------------
# Atheris parameters:
# -timeout: the maximum time to run a single test case
# -max_total_time: the maximum time to run the fuzzer
# -rss_limit_mb: the maximum memory usage in MB
LD_PRELOAD=$(python3 -c 'import atheris; print(atheris.path())')/asan_with_fuzzer.so \
ASAN_OPTIONS=detect_odr_violation=0:symbolize=0:detect_leaks=0 \
python3 ./fuzz_driver.py  -timeout=60 \
                          -max_total_time=6000 \
                          -rss_limit_mb=4096
