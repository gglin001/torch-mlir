module {
  func.func @main_graph(%arg0: !torch.vtensor<[1,56,56,128],f32>) -> !torch.vtensor<[1,56,56,128],f32> attributes {torch.onnx_meta.ir_version = 7 : si64, torch.onnx_meta.opset_version = 14 : si64, torch.onnx_meta.producer_name = "pytorch", torch.onnx_meta.producer_version = "2.3.0"} {
    %0 = torch.operator "onnx.Constant"() {torch.onnx.value = dense_resource<_> : tensor<1xsi64>} : () -> !torch.vtensor<[1],si64>
    %1 = torch.operator "onnx.Constant"() {torch.onnx.value = dense_resource<__1> : tensor<1xsi64>} : () -> !torch.vtensor<[1],si64>
    %2 = torch.operator "onnx.Constant"() {torch.onnx.value = dense_resource<__2> : tensor<1xsi64>} : () -> !torch.vtensor<[1],si64>
    %3 = torch.operator "onnx.Constant"() {torch.onnx.value = dense_resource<__3> : tensor<1xsi64>} : () -> !torch.vtensor<[1],si64>
    %4 = torch.operator "onnx.Slice"(%arg0, %1, %2, %0, %3) : (!torch.vtensor<[1,56,56,128],f32>, !torch.vtensor<[1],si64>, !torch.vtensor<[1],si64>, !torch.vtensor<[1],si64>, !torch.vtensor<[1],si64>) -> !torch.vtensor<[1,53,56,128],f32>
    %5 = torch.operator "onnx.Constant"() {torch.onnx.value = dense_resource<__4> : tensor<1xsi64>} : () -> !torch.vtensor<[1],si64>
    %6 = torch.operator "onnx.Constant"() {torch.onnx.value = dense_resource<__5> : tensor<1xsi64>} : () -> !torch.vtensor<[1],si64>
    %7 = torch.operator "onnx.Constant"() {torch.onnx.value = dense_resource<__6> : tensor<1xsi64>} : () -> !torch.vtensor<[1],si64>
    %8 = torch.operator "onnx.Constant"() {torch.onnx.value = dense_resource<__7> : tensor<1xsi64>} : () -> !torch.vtensor<[1],si64>
    %9 = torch.operator "onnx.Slice"(%arg0, %6, %7, %5, %8) : (!torch.vtensor<[1,56,56,128],f32>, !torch.vtensor<[1],si64>, !torch.vtensor<[1],si64>, !torch.vtensor<[1],si64>, !torch.vtensor<[1],si64>) -> !torch.vtensor<[1,3,56,128],f32>
    %10 = torch.operator "onnx.Concat"(%4, %9) {torch.onnx.axis = 1 : si64} : (!torch.vtensor<[1,53,56,128],f32>, !torch.vtensor<[1,3,56,128],f32>) -> !torch.vtensor<[1,56,56,128],f32>
    return %10 : !torch.vtensor<[1,56,56,128],f32>
  }
}

{-#
  dialect_resources: {
    builtin: {
      _: "0x080000000100000000000000",
      __1: "0x080000000300000000000000",
      __2: "0x08000000FFFFFFFFFFFFFF7F",
      __3: "0x080000000100000000000000",
      __4: "0x080000000100000000000000",
      __5: "0x080000000000000000000000",
      __6: "0x080000000300000000000000",
      __7: "0x080000000100000000000000"
    }
  }
#-}

