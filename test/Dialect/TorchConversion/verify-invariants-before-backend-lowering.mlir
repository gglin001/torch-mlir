// RUN: torch-mlir-opt -split-input-file -verify-diagnostics %s -torch-verify-invariants-before-backend-lowering

// -----

func.func @unknown_rank(%arg0: !torch.vtensor<[],f32>) {
  // expected-error@+2 {{unsupported by backend lowering: tensor with unknown rank or dtype}}
  // expected-note@+1 {{this is likely due to a missing shape transfer function in shape_lib_gen.py}}
  %0 = torch.aten.mul.Tensor %arg0, %arg0 : !torch.vtensor<[],f32>, !torch.vtensor<[],f32> -> !torch.vtensor<*,f32>
  return
}

// -----

func.func @unknown_dtype(%arg0: !torch.vtensor<[],f32>) {
  // expected-error@+2 {{unsupported by backend lowering: tensor with unknown rank or dtype}}
  // expected-note@+1 {{this is likely due to a missing shape transfer function in shape_lib_gen.py}}
  %0 = torch.aten.mul.Tensor %arg0, %arg0 : !torch.vtensor<[],f32>, !torch.vtensor<[],f32> -> !torch.vtensor<[],unk>
  return
}

// -----

func.func @unresolved_operator(%arg0: !torch.vtensor<[],f32>, %arg1: !torch.int) {
  // expected-error@+2 {{unsupported by backend lowering: `torch.operator` op}}
  // expected-note@+1 {{this is likely due to a missing op that needs to be generated by torch_ods_gen.py}}
  torch.operator "aten.mul.Scalar"(%arg0, %arg1) : (!torch.vtensor<[],f32>, !torch.int) -> !torch.vtensor<[],f32>
  return
}
