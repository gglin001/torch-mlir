# gather
https://github.com/llvm/torch-mlir/pull/2726
git fetch gh pull/2726/head:gaurav/lower_gather

# constant
https://github.com/llvm/torch-mlir/pull/2748
git fetch gh pull/2748/head:gaurav/onnx_constant

# flattern
https://github.com/llvm/torch-mlir/pull/2760
git fetch gh pull/2748/head:daveliddell/dliddell-onnx-flatten

# pip3 install onnxoptimizer
# pip3 install onnxsim

python issues/swin_t/swin_opset_cvt.py --opset=14 \
    issues/swin_t/swin-transform.onnx \
    issues/swin_t/swin-transform.opset14.onnx

onnxsim --skip-shape-inference \
    issues/swin_t/swin-transform.opset14.onnx \
    issues/swin_t/swin-transform.opset14.sim.onnx

python -m onnxoptimizer \
    issues/swin_t/swin-transform.opset14.sim.onnx \
    issues/swin_t/swin-transform.opset14.sim.opt.onnx

python issues/swin_t/swin_shape_infer.py --clear \
    issues/swin_t/swin-transform.opset14.sim.opt.onnx \
    issues/swin_t/swin-transform.opset14.sim.opt.shape.onnx

python issues/swin_t/swin_slice_opt.py \
    issues/swin_t/swin-transform.opset14.sim.opt.shape.onnx \
    issues/swin_t/swin-transform.opset14.sim.opt.shape.slice.onnx

# import onnx
python -m torch_mlir.tools.import_onnx \
    -o issues/swin_t/swin-transform.opset14.sim.opt.shape.slice.onnx.mlir \
    issues/swin_t/swin-transform.opset14.sim.opt.shape.slice.onnx

# torch opt
torch-mlir-opt \
    --convert-torch-onnx-to-torch \
    --dump-pass-pipeline \
    -o issues/swin_t/swin-transform.opset14.sim.opt.shape.slice.onnx.torch.mlir \
    issues/swin_t/swin-transform.opset14.sim.opt.shape.slice.onnx.mlir

# stablehlo
# torch-mlir-opt \
#     --convert-torch-to-stablehlo \
#     -o issues/swin_t/swin-transform.opset14.sim.opt.shape.slice.onnx.torch.stablehlo.mlir \
#     issues/swin_t/swin-transform.opset14.sim.opt.shape.slice.onnx.torch.mlir

torch-mlir-opt \
    --pass-pipeline='builtin.module(torch-simplification-pipeline{decompose-complex-ops},torch-backend-to-stablehlo-backend-pipeline)' \
    -o issues/swin_t/swin-transform.opset14.sim.opt.shape.slice.onnx.torch.stablehlo.mlir \
    issues/swin_t/swin-transform.opset14.sim.opt.shape.slice.onnx.torch.mlir

# iree-compile
iree-compile \
    --iree-hal-target-backends=llvm-cpu \
    -o issues/swin_t/swin-transform.opset14.sim.opt.shape.slice.onnx.torch.mlir.iree.vmfb \
    issues/swin_t/swin-transform.opset14.sim.opt.shape.slice.onnx.torch.mlir \
    2>&1 | tee issues/swin_t/swin-transform.opset14.sim.opt.shape.slice.onnx.torch.mlir.iree.vmfb.log

# -debug-only=torch-lower-to-backend-contract \
# --debug \
# -debug-only=torch-lower-to-backend-contract
# --dump-pass-pipeline \

# ###########################################################
# debug
torch-mlir-opt \
    --torch-simplification-pipeline \
    -o issues/swin_t/swin-transform.opset14.sim.opt.shape.slice.onnx.torch.simplification.mlir \
    issues/swin_t/swin-transform.opset14.sim.opt.shape.slice.onnx.torch.mlir

iree-compile \
    --iree-hal-target-backends=llvm-cpu \
    -o issues/swin_t/swin-transform.opset14.sim.opt.shape.slice.onnx.torch.simplification.mlir.iree.vmfb \
    issues/swin_t/swin-transform.opset14.sim.opt.shape.slice.onnx.torch.simplification.mlir

torch-mlir-opt \
    --convert-torch-to-stablehlo \
    -o issues/swin_t/swin-transform.opset14.sim.opt.shape.slice.onnx.torch.simplification.mlir.stablehlo.mlir \
    issues/swin_t/swin-transform.opset14.sim.opt.shape.slice.onnx.torch.simplification.mlir

iree-run-module \
    --device=local-task \
    --module=issues/swin_t/swin-transform.opset14.sim.opt.shape.slice.onnx.torch.simplification.mlir.iree.vmfb \
    --function=torch-jit-export \
    --input=1x3x224x224xf32=0.01 \
    --output=-
