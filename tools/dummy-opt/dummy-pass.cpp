#include "dummy-pass.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Pass/Pass.h"

namespace dummy {

using namespace mlir;

struct DummyPass : public PassWrapper<DummyPass, OperationPass<>> {
  DummyPass() = default;
  DummyPass(const DummyPass &pass) {}

  StringRef getArgument() const final { return "dummy-pass"; }

  StringRef getDescription() const final { return "dummy-pass for test"; }

  void runOnOperation() override;
};

void DummyPass::runOnOperation() {
  Operation *op = getOperation();
  llvm::errs() << "DummyPass";
  (void)(op);
}

std::unique_ptr<Pass> createDummyPass() {
  return std::make_unique<dummy::DummyPass>();
}

} // namespace dummy
