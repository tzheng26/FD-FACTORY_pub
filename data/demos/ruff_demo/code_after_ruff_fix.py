import atheris
from atheris import FuzzedDataProvider
import sys

with atheris.instrument_imports():
    import torch


class SecurityAlert(Exception):
    pass


@atheris.instrument_func
def data_constructor(input_bytes: bytes) -> dict:
    fdp = FuzzedDataProvider(input_bytes)

    input_shape = fdp.ConsumeIntInRange(1, 5)
    input = torch.randn(input_shape)

    other_is_tensor = fdp.ConsumeBool()
    if other_is_tensor:
        other_shape = fdp.ConsumeIntInRange(1, input_shape)
        other = torch.randn(other_shape)
    else:
        other = fdp.ConsumeFloat()

    out_is_provided = fdp.ConsumeBool()
    if out_is_provided:
        out = torch.empty_like(input)
    else:
        out = None

    kwargs = {
        "input": input,
        "other": other,
        "alpha": alpha,
        "out": out,
    }

    return kwargs


# Target function
@atheris.instrument_func
def FuzzTarget(**kwargs):
    try:
        input = kwargs.get("input")
        other = kwargs.get("other")
        alpha = kwargs.get("alpha", 1)
        out = kwargs.get("out")

        result = torch.add(input, other, alpha=alpha, out=out)

        return result

    except Exception as e:
        if "incompatible size" in str(e) or "expected scalar type" in str(e):
            print(f"Non-critical error: {e}")
            return None
        else:
            raise SecurityAlert("Potential vulnerability detected: " + str(e))

    finally:
        pass


@atheris.instrument_func
def entry_point(input_bytes: bytes):
    kwargs = data_constructor(input_bytes)
    return FuzzTarget(**kwargs)


def main():
    atheris.Setup(sys.argv, entry_point)
    atheris.Fuzz()


if __name__ == "__main__":
    main()
