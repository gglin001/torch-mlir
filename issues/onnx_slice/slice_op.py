import torch
from torch import nn
from torch.nn import functional as F


class Model(nn.Module):
    # def __init__(self):
    #     pass

    def forward(self, x):
        # def forward(self, x, shape):
        # x = x.reshape(shape)
        x0 = x[:, 3:, :, :]
        x1 = x[:, 0:3, :, :]
        x = torch.concat([x0, x1], dim=1)
        # x = F.relu(x)
        return x


if __name__ == "__main__":
    model = Model()

    # arg0 = torch.randn(size=[1, 3136, 128], dtype=torch.float32)
    # arg1 = torch.asarray([1, 56, 56, 128], dtype=torch.int64)
    arg0 = torch.randn(size=[1, 56, 56, 128], dtype=torch.float32)
    args = (
        arg0,
        # arg1,
    )

    fp = "issues/onnx_slice/slice_op.onnx"
    torch.onnx.export(
        model,
        args=args,
        f=fp,
        opset_version=14,
        keep_initializers_as_inputs=True,
    )
