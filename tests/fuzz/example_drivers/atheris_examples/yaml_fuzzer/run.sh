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
# -artifact_prefix: the directory to save crash files
LD_PRELOAD=$(python3 -c 'import atheris; print(atheris.path())')/asan_with_fuzzer.so \
ASAN_OPTIONS=detect_odr_violation=0:symbolize=0:detect_leaks=0 \
python3 yaml_fuzzer.py  -timeout=60 \
                        -max_total_time=60 \
                        -artifact_prefix="./"