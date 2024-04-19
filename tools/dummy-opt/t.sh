args=(
  # --debug
  --dummy-pass
  --mlir-print-ir-after-all
  -o tools/dummy-opt/dummy.opt.mlir
  tools/dummy-opt/dummy.mlir
)
dummy-opt "${args[@]}"
