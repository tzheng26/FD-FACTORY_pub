import sys
import atheris
from atheris import FuzzedDataProvider

with atheris.instrument_imports():
    import torch


@atheris.instrument_func
def data_constructor(input_bytes: bytes) -> dict:
    fdp = FuzzedDataProvider(input_bytes)

    in_features = fdp.ConsumeIntInRange(1, 100)
    n_classes = fdp.ConsumeIntInRange(in_features + 1, 200)
    cutoffs = sorted(
        list(set(fdp.ConsumeIntListInRange(n_classes - 1, 1, n_classes - 1)))
    )
    div_value = fdp.ConsumeFloatInRange(0.0, 10.0)
    head_bias = fdp.ConsumeBool()

    assert len(cutoffs) < n_classes
    assert max(cutoffs) < n_classes

    kwargs = {
        "in_features": in_features,
        "n_classes": n_classes,
        "cutoffs": cutoffs,
        "div_value": div_value,
        "head_bias": head_bias,
    }
    return kwargs


@atheris.instrument_func
def FuzzTarget(**kwargs):
    in_features = kwargs.get("in_features")
    n_classes = kwargs.get("n_classes")
    cutoffs = kwargs.get("cutoffs")
    div_value = kwargs.get("div_value", 4.0)
    head_bias = kwargs.get("head_bias", False)

    model = torch.nn.AdaptiveLogSoftmaxWithLoss(
        in_features, n_classes, cutoffs, div_value, head_bias
    )
    N = 10
    input = torch.randn(N, in_features)
    target = torch.randint(0, n_classes, (N,))
    output, loss = model(input, target)

    return output, loss


@atheris.instrument_func
def entry_point(input_bytes: bytes):
    kwargs = data_constructor(input_bytes)
    return FuzzTarget(**kwargs)


def main():
    atheris.Setup(sys.argv, entry_point)
    atheris.Fuzz()


if __name__ == "__main__":
    main()
