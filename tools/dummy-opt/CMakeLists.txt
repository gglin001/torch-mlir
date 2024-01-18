add_llvm_executable(dummy-opt dummy-opt.cpp dummy-pass.cpp)

install(TARGETS dummy-opt
EXPORT TorchMLIRTargets
RUNTIME DESTINATION ${LLVM_TOOLS_INSTALL_DIR}
COMPONENT dummy-opt)

set(dependency_libraries)
if(TORCH_MLIR_ENABLE_STABLEHLO)
  list(APPEND dependency_libraries StablehloRegister)
endif()

target_link_libraries(dummy-opt PRIVATE
  MLIROptLib
  # MLIRTransforms
  TorchMLIRInitAll
  # TorchMLIRTorchDialect
  # TorchMLIRTorchPasses
  ${dependency_libraries}
)
