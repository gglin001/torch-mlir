# gen issues/onnx_slice_2/slice_op.onnx
python issues/onnx_slice_2/slice_op.py

# import onnx
python -m torch_mlir.tools.import_onnx issues/onnx_slice_2/slice_op.onnx -o issues/onnx_slice_2/slice_op.onnx.mlir

# torch opt
torch-mlir-opt \
    --convert-torch-onnx-to-torch \
    -o issues/onnx_slice_2/slice_op.onnx.mlir.torch.mlir \
    issues/onnx_slice_2/slice_op.onnx.mlir

# stablehlo
torch-mlir-opt \
    --pass-pipeline='builtin.module(torch-simplification-pipeline{decompose-complex-ops},torch-backend-to-stablehlo-backend-pipeline)' \
    -o issues/onnx_slice_2/slice_op.onnx.mlir.torch.stablehlo.mlir \
    issues/onnx_slice_2/slice_op.onnx.mlir.torch.mlir

# - iree-compile
#
iree-compile \
    --iree-hal-target-backends=llvm-cpu \
    -o issues/onnx_slice_2/slice_op.onnx.mlir.torch.mlir.iree.vmfb \
    issues/onnx_slice_2/slice_op.onnx.mlir.torch.mlir

iree-run-module \
    --device=local-task \
    --module=issues/onnx_slice_2/slice_op.onnx.mlir.torch.mlir.iree.vmfb \
    --function=main_graph \
    --input=1x14x14x512xf32=0.01 \
    --output=-

## use fx_import

# gen issues/onnx_slice_2/slice_op.fx_import.mlir
python issues/onnx_slice_2/fx_import.py

# stablehlo
# gen issues/onnx_slice_2/slice_op.fx_import.mlir.stablehlo.mlir
torch-mlir-opt \
    --convert-torch-to-stablehlo \
    -o issues/onnx_slice_2/slice_op.fx_import.mlir.stablehlo.mlir \
    issues/onnx_slice_2/slice_op.fx_import.mlir

# iree-compile, works

iree-compile \
    --iree-hal-target-backends=llvm-cpu \
    -o issues/onnx_slice_2/slice_op.fx_import.mlir.iree.vmfb \
    issues/onnx_slice_2/slice_op.fx_import.mlir

iree-run-module \
    --device=local-task \
    --module=issues/onnx_slice_2/slice_op.fx_import.mlir.iree.vmfb \
    --function=main \
    --input=1x56x56x128xf32=0.01 \
    --output=-
