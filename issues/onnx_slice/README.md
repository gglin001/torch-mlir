# onnx.slice issue

## use onnx_importer

- cvt

build torch-mlir(optional iree) first, and deps

```bash
# make sure PWD==path_to/torch-mlir

# gen issues/onnx_slice/slice_op.onnx
python issues/onnx_slice/slice_op.py

# import onnx
python -m torch_mlir.tools.import_onnx issues/onnx_slice/slice_op.onnx -o issues/onnx_slice/slice_op.onnx.mlir

# torch opt
torch-mlir-opt \
    --convert-torch-onnx-to-torch \
    -o issues/onnx_slice/slice_op.onnx.mlir.torch.mlir \
    issues/onnx_slice/slice_op.onnx.mlir
```

- convert to stablehlo

```bash
# stablehlo
torch-mlir-opt \
    --convert-torch-to-stablehlo \
    -o issues/onnx_slice/slice_op.onnx.mlir.torch.stablehlo.mlir \
    issues/onnx_slice/slice_op.onnx.mlir.torch.mlir

# -debug \

#
# short error log(no `-debug`):
#
>   torch-mlir-opt \
    --convert-torch-to-stablehlo \
    -o issues/onnx_slice/slice_op.onnx.mlir.torch.stablehlo.mlir \
    issues/onnx_slice/slice_op.onnx.mlir.torch.mlir

issues/onnx_slice/slice_op.onnx.mlir.torch.mlir:18:11: error: failed to legalize operation 'torch.aten.slice.Tensor' that was explicitly marked illegal
    %13 = torch.aten.slice.Tensor %arg0, %10, %6, %8, %12 : !torch.vtensor<[1,56,56,128],f32>, !torch.int, !torch.int, !torch.int, !torch.int -> !torch.vtensor<[1,53,56,128],f32>
          ^
issues/onnx_slice/slice_op.onnx.mlir.torch.mlir:18:11: note: see current operation: %41 = "torch.aten.slice.Tensor"(%arg0, %34, %22, %28, %40) : (!torch.vtensor<[1,56,56,128],f32>, !torch.int, !torch.int, !torch.int, !torch.int) -> !torch.vtensor<[1,53,56,128],f32>
```

- iree-compile

```bash
iree-compile \
    --iree-hal-target-backends=llvm-cpu \
    -o issues/onnx_slice/slice_op.onnx.mlir.torch.mlir.iree.vmfb \
    issues/onnx_slice/slice_op.onnx.mlir.torch.mlir

#
# error log
#
build/install/bin/iree-compile \
    --iree-hal-target-backends=llvm-cpu \
    -o issues/onnx_slice/slice_op.onnx.mlir.torch.mlir.iree.vmfb \
    issues/onnx_slice/slice_op.onnx.mlir.torch.mlir

issues/onnx_slice/slice_op.onnx.mlir.torch.mlir:18:11: error: unimplemented: dim is not constant
    %13 = torch.aten.slice.Tensor %arg0, %10, %6, %8, %12 : !torch.vtensor<[1,56,56,128],f32>, !torch.int, !torch.int, !torch.int, !torch.int -> !torch.vtensor<[1,53,56,128],f32>
          ^
issues/onnx_slice/slice_op.onnx.mlir.torch.mlir:18:11: note: see current operation: %62 = "torch.aten.slice.Tensor"(%arg0, %48, %28, %38, %58) : (!torch.vtensor<[1,56,56,128],f32>, !torch.int, !torch.int, !torch.int, !torch.int) -> !torch.vtensor<[1,53,56,128],f32>
issues/onnx_slice/slice_op.onnx.mlir.torch.mlir:18:11: error: failed to legalize operation 'torch.aten.slice.Tensor' that was explicitly marked illegal
    %13 = torch.aten.slice.Tensor %arg0, %10, %6, %8, %12 : !torch.vtensor<[1,56,56,128],f32>, !torch.int, !torch.int, !torch.int, !torch.int -> !torch.vtensor<[1,53,56,128],f32>
          ^
issues/onnx_slice/slice_op.onnx.mlir.torch.mlir:18:11: note: see current operation: %55 = "torch.aten.slice.Tensor"(%arg0, %45, %27, %36, %54) : (!torch.vtensor<[1,56,56,128],f32>, !torch.int, !torch.int, !torch.int, !torch.int) -> !torch.vtensor<[1,53,56,128],f32>
```

## use fx_import

```bash
# gen issues/onnx_slice/slice_op.fx_import.mlir
python issues/onnx_slice/fx_import.py
```

stablehlo, works

```bash
# stablehlo
# gen issues/onnx_slice/slice_op.fx_import.mlir.stablehlo.mlir
torch-mlir-opt \
    --pass-pipeline='builtin.module(torch-simplification-pipeline{decompose-complex-ops},torch-backend-to-stablehlo-backend-pipeline)' \
    -o issues/onnx_slice/slice_op.fx_import.mlir.stablehlo.mlir \
    issues/onnx_slice/slice_op.fx_import.mlir
```

iree-compile, works

```bash
path_to/iree-compile \
    --iree-hal-target-backends=llvm-cpu \
    -o issues/onnx_slice/slice_op.fx_import.mlir.iree.vmfb \
    issues/onnx_slice/slice_op.fx_import.mlir

path_to/iree-run-module \
    --device=local-task \
    --module=issues/onnx_slice/slice_op.fx_import.mlir.iree.vmfb \
    --function=main \
    --input=1x56x56x128xf32=0.01 \
    --output=@iree_out.npy
```

iree-run-module \
 --device=local-task \
 --module=issues/onnx_slice/slice_op.onnx.mlir.torch.mlir.iree.vmfb \
 --function=main_graph \
 --input=1x56x56x128xf32=0.01 \
 --output=-
