#pragma once

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Pass/Pass.h"

namespace dummy {

std::unique_ptr<::mlir::Pass> createDummyPass();

inline void registerDummyPass() {
  ::mlir::registerPass(
      []() -> std::unique_ptr<::mlir::Pass> { return createDummyPass(); });
}

} // namespace dummy
