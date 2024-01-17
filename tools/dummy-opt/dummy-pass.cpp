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

    // demo
    rewriter.replaceOpWithNewOp<Torch::ConstantBoolOp>(op, false);

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
