"""
The `first_check.py` script is used to verify the 
correctness of the fuzzing environment and 
configuration.

`first_check.py` provides an invalid target function 
that will not increase coverage. 
Therefore, it should theoretically output: 
"ERROR: no interesting inputs were found. 
Is the code instrumented for coverage? Exiting."

If other errors are triggered during fuzzing, 
it may indicate issues with the fuzzing 
environment or configuration. In such cases, 
the environment and configuration need to be adjusted.

A common error is memory leak issues reported 
by the fuzzer due to Python's inherent memory 
leaks. To address this, add 
`ASAN_OPTIONS=detect_leaks=0` when running 
the fuzz driver.
"""

import atheris
import sys

@atheris.instrument_func
def TestOneInput(input_bytes):
    print("a")
    

def main():
  atheris.Setup(sys.argv, TestOneInput)
  atheris.Fuzz()


if __name__ == "__main__":
  main()

