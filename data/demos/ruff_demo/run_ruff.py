import shutil
import subprocess
from pathlib import Path
from typing import Optional


# A demonstration version of the Ruff check in FD-FACTORY
def check_with_ruff(code_before_fix: str, code_after_fix: str, ruff_log: str) -> None:
    # Open a single file to save all outputs
    with open(ruff_log, "w") as f:
        # Run ruff check
        result = subprocess.run(
            ["ruff", "check", str(code_after_fix)],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
        )
        f.write(f"-" * 20 + "\n")
        f.write("Errors detected:\n")
        f.write(result.stdout)
        f.write(f"\nExit code: {result.returncode}\n\n")

        # Run ruff diff
        result = subprocess.run(
            ["ruff", "check", "--diff", str(code_after_fix)],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
        )
        f.write(f"-" * 20 + "\n")
        f.write("Proposed fixes (diff):\n")
        f.write(result.stdout)
        f.write(f"\nExit code: {result.returncode}\n\n")

        # Run ruff fix
        result = subprocess.run(
            ["ruff", "check", "--fix", str(code_after_fix)],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
        )
        f.write(f"-" * 20 + "\n")
        f.write("Fixes applied:\n")
        f.write(result.stdout)
        f.write(f"\nExit code: {result.returncode}\n\n")

    print(f"Ruff check completed. Output saved to {ruff_log}")


if __name__ == "__main__":
    # Run the ruff check
    code_before_fix = "code_before_ruff_fix.py"
    code_after_fix = "code_after_ruff_fix.py"
    ruff_log = "ruff_log.txt"
    shutil.copy(code_before_fix, code_after_fix)
    check_with_ruff(code_before_fix, code_after_fix, ruff_log)
