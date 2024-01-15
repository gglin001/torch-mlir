# Copyright 2023 Advanced Micro Devices, Inc
#
# Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Also available under a BSD-style license. See LICENSE.

# from python/torch_mlir/extras/fx_importer.py

from typing import Optional

import torch
import torch.export
import torch.nn as nn

from torch_mlir.extras.fx_importer import FxImporter
from torch_mlir import ir
from torch_mlir.dialects import torch as torch_d


from slice_op import Model


def export_and_import(
    f,
    *args,
    fx_importer: Optional[FxImporter] = None,
    constraints: Optional[torch.export.Constraint] = None,
    **kwargs,
):
    context = ir.Context()
    torch_d.register_dialect(context)

    if fx_importer is None:
        fx_importer = FxImporter(context=context)
    prog = torch.export.export(f, args, kwargs, constraints=constraints)
    fx_importer.import_frozen_exported_program(prog)
    # breakpoint()
    return fx_importer.module_op


if __name__ == "__main__":
    model = Model()
    # arg0 = torch.randn(size=[1, 56, 56, 128], dtype=torch.float32)
    arg0 = torch.randn(size=[1, 14, 14, 512], dtype=torch.float32)
    args = (arg0,)

    m = export_and_import(model, *args)
    fp = 'issues/onnx_slice_2/slice_op.fx_import.mlir'
    m.print(file=open(fp, 'w'))
    print(m)
