#include "dummy-pass.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Tensor/IR/Tensor.h"
#include "mlir/Dialect/Tosa/IR/TosaOps.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Transforms/DialectConversion.h"

#include "torch-mlir/Dialect/Torch/IR/TorchDialect.h"
#include "torch-mlir/Dialect/Torch/IR/TorchOps.h"
#include "torch-mlir/Dialect/Torch/IR/TorchTypes.h"
#include "torch-mlir/Dialect/Torch/Utils/Utils.h"

namespace dummy {

using namespace mlir;
using namespace mlir::torch;

struct DummyPass : public PassWrapper<DummyPass, OperationPass<func::FuncOp>> {
  DummyPass() = default;
  DummyPass(const DummyPass &pass) {}

  StringRef getArgument() const final { return "dummy-pass"; }

  StringRef getDescription() const final { return "dummy-pass for test"; }

  void runOnOperation() override;
};

template <typename AtenOpT>
class Converter : public OpConversionPattern<AtenOpT> {
public:
  using OpConversionPattern<AtenOpT>::OpConversionPattern;
  using OpAdaptor = typename AtenOpT::Adaptor;
  LogicalResult
  matchAndRewrite(AtenOpT op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    auto loc = op.getLoc();

    rewriter.replaceOpWithNewOp<Torch::ConstantBoolOp>(op, false);

    // demo
    /*
      func.func @forward(%arg0: !torch.vtensor<[1,3,224,224],f32>) ->
      !torch.vtensor<[1,3,224,224],f32> { %0 = torch.vtensor.literal(dense<0> :
      tensor<1xsi64>) : !torch.vtensor<[1],si64> return %arg0 :
      !torch.vtensor<[1,3,224,224],f32>
      }
    */
    /*
    rewriter.eraseOp(op);
    auto si64Type = IntegerType::get(op.getContext(), 64, IntegerType::Signed);
    auto ValueTensoAttr = DenseElementsAttr::get(
        RankedTensorType::get({1}, si64Type), {APInt::getZero(64)});
    llvm::ArrayRef<int64_t> shape{1};
    auto valueTensorLiteralType = Torch::ValueTensorType::get(
        op.getContext(), llvm::ArrayRef<int64_t>{1}, si64Type);
    Value ValueTensorLiteral = rewriter.create<Torch::ValueTensorLiteralOp>(
        loc, valueTensorLiteralType, ValueTensoAttr);
    Value indicesList = rewriter.create<Torch::PrimListConstructOp>(
        loc,
        Torch::ListType::get(Torch::OptionalType::get(valueTensorLiteralType)),
        ValueRange{ValueTensorLiteral});
    */

    return success();
  }
};

void DummyPass::runOnOperation() {
  MLIRContext *context = &getContext();

  ConversionTarget target(*context);
  target.addLegalDialect<tensor::TensorDialect, arith::ArithDialect>();
  target.addLegalDialect<Torch::TorchDialect>();

  TypeConverter typeConverter;
  typeConverter.addConversion([](Type type) { return type; });

  RewritePatternSet patterns(context);

  target.addIllegalOp<Torch::ConstantNoneOp>();
  patterns.add<Converter<Torch::ConstantNoneOp>>(typeConverter, context);

  if (failed(
          applyPartialConversion(getOperation(), target, std::move(patterns))))
    return signalPassFailure();
}

std::unique_ptr<Pass> createDummyPass() {
  return std::make_unique<dummy::DummyPass>();
}

} // namespace dummy
