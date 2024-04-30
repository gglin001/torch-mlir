args=(
  build/test
  --show-tests
  --debug
)
lit "${args[@]}"

###############################################################################

args=(
  build/test
  -v -a
  ## disable `FileCheck` first
  # --filter "Dialect/TMTensor/convert_to_loops.mlir"
  # --filter "Dialect/TMTensor/canonicalize.mlir"
  --filter "Dialect/TMTensor/bufferize.mlir"
)
lit "${args[@]}" | tee _demos/lit.run.dirty.mlir

###############################################################################
