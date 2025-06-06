import atheris
import sys
import torch
import numpy as np
import io
import struct

@atheris.instrument_func
def TestOneInput(input_bytes):
    f = io.BytesIO(input_bytes)
    try:
        # Read and prepare the tensors
        len1, len2 = struct.unpack("HH", f.read(4))
        tensor1 = torch.from_numpy(np.frombuffer(f.read(len1), dtype=np.float32))
        tensor2 = torch.from_numpy(np.frombuffer(f.read(len2), dtype=np.float32))

        # Read and prepare the alpha
        alpha = struct.unpack("f", f.read(4))[0]

        # Perform the operation
        result = torch.add(tensor1, tensor2, alpha=alpha)

        # Check the result
        assert isinstance(result, torch.Tensor)

    except struct.error:
        # Not enough data for unpacking, ignore
        pass
    except ValueError:
        # Data was not a valid tensor, ignore
        pass

atheris.Setup(sys.argv, TestOneInput)
atheris.Fuzz()
