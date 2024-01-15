import torch
from torch import nn
from torch.nn import functional as F


class Model(nn.Module):
    # def __init__(self):
    #     pass

    def forward(self, x):
        # def forward(self, x, shape):
        # x = x.reshape(shape)
        x0 = x[0:, 0::2, 0::2, :]
        x1 = x[0:, 1::2, 1::2, :]
        # x2 = x[0:, 1::2, 0::2, :]
        # x3 = x[0:, 1::2, 1::2, :]
        # breakpoint()
        # x = torch.concat([x0, x1, x2, x3], dim=-1)
        x = torch.concat([x0, x1], dim=-1)
        return x


if __name__ == "__main__":
    model = Model()

    # arg0 = torch.randn(size=[1, 3136, 128], dtype=torch.float32)
    # arg1 = torch.asarray([1, 56, 56, 128], dtype=torch.int64)
    arg0 = torch.randn(size=[1, 14, 14, 512], dtype=torch.float32)
    args = (
        arg0,
        # arg1,
    )

    fp = "issues/onnx_slice_2/slice_op.onnx"
    torch.onnx.export(
        model,
        args=args,
        f=fp,
        opset_version=14,
        # opset_version=12,
        # keep_initializers_as_inputs=True,
    )
