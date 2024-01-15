module {
  func.func @main_graph(%arg0: !torch.vtensor<[1,56,56,128],f32>) -> !torch.vtensor<[1,56,56,128],f32> attributes {torch.onnx_meta.ir_version = 7 : si64, torch.onnx_meta.opset_version = 14 : si64, torch.onnx_meta.producer_name = "pytorch", torch.onnx_meta.producer_version = "2.3.0"} {
    %0 = torch.vtensor.literal(dense_resource<_> : tensor<1xsi64>) : !torch.vtensor<[1],si64>
    %1 = torch.vtensor.literal(dense_resource<__1> : tensor<1xsi64>) : !torch.vtensor<[1],si64>
    %2 = torch.vtensor.literal(dense_resource<__2> : tensor<1xsi64>) : !torch.vtensor<[1],si64>
    %3 = torch.vtensor.literal(dense_resource<__3> : tensor<1xsi64>) : !torch.vtensor<[1],si64>
    %int0 = torch.constant.int 0
    %int0_0 = torch.constant.int 0
    %4 = torch.prim.NumToTensor.Scalar %int0_0 : !torch.int -> !torch.vtensor<[1],si64>
    %5 = torch.aten.index_select %1, %int0, %4 : !torch.vtensor<[1],si64>, !torch.int, !torch.vtensor<[1],si64> -> !torch.vtensor<[1],si64>
    %6 = torch.aten.item %5 : !torch.vtensor<[1],si64> -> !torch.int
    %7 = torch.aten.index_select %2, %int0, %4 : !torch.vtensor<[1],si64>, !torch.int, !torch.vtensor<[1],si64> -> !torch.vtensor<[1],si64>
    %8 = torch.aten.item %7 : !torch.vtensor<[1],si64> -> !torch.int
    %9 = torch.aten.index_select %0, %int0, %4 : !torch.vtensor<[1],si64>, !torch.int, !torch.vtensor<[1],si64> -> !torch.vtensor<[1],si64>
    %10 = torch.aten.item %9 : !torch.vtensor<[1],si64> -> !torch.int
    %11 = torch.aten.index_select %3, %int0, %4 : !torch.vtensor<[1],si64>, !torch.int, !torch.vtensor<[1],si64> -> !torch.vtensor<[1],si64>
    %12 = torch.aten.item %11 : !torch.vtensor<[1],si64> -> !torch.int
    %13 = torch.aten.slice.Tensor %arg0, %10, %6, %8, %12 : !torch.vtensor<[1,56,56,128],f32>, !torch.int, !torch.int, !torch.int, !torch.int -> !torch.vtensor<[1,53,56,128],f32>
    %14 = torch.vtensor.literal(dense_resource<__4> : tensor<1xsi64>) : !torch.vtensor<[1],si64>
    %15 = torch.vtensor.literal(dense_resource<__5> : tensor<1xsi64>) : !torch.vtensor<[1],si64>
    %16 = torch.vtensor.literal(dense_resource<__6> : tensor<1xsi64>) : !torch.vtensor<[1],si64>
    %17 = torch.vtensor.literal(dense_resource<__7> : tensor<1xsi64>) : !torch.vtensor<[1],si64>
    %int0_1 = torch.constant.int 0
    %int0_2 = torch.constant.int 0
    %18 = torch.prim.NumToTensor.Scalar %int0_2 : !torch.int -> !torch.vtensor<[1],si64>
    %19 = torch.aten.index_select %15, %int0_1, %18 : !torch.vtensor<[1],si64>, !torch.int, !torch.vtensor<[1],si64> -> !torch.vtensor<[1],si64>
    %20 = torch.aten.item %19 : !torch.vtensor<[1],si64> -> !torch.int
    %21 = torch.aten.index_select %16, %int0_1, %18 : !torch.vtensor<[1],si64>, !torch.int, !torch.vtensor<[1],si64> -> !torch.vtensor<[1],si64>
    %22 = torch.aten.item %21 : !torch.vtensor<[1],si64> -> !torch.int
    %23 = torch.aten.index_select %14, %int0_1, %18 : !torch.vtensor<[1],si64>, !torch.int, !torch.vtensor<[1],si64> -> !torch.vtensor<[1],si64>
    %24 = torch.aten.item %23 : !torch.vtensor<[1],si64> -> !torch.int
    %25 = torch.aten.index_select %17, %int0_1, %18 : !torch.vtensor<[1],si64>, !torch.int, !torch.vtensor<[1],si64> -> !torch.vtensor<[1],si64>
    %26 = torch.aten.item %25 : !torch.vtensor<[1],si64> -> !torch.int
    %27 = torch.aten.slice.Tensor %arg0, %24, %20, %22, %26 : !torch.vtensor<[1,56,56,128],f32>, !torch.int, !torch.int, !torch.int, !torch.int -> !torch.vtensor<[1,3,56,128],f32>
    %28 = torch.prim.ListConstruct %13, %27 : (!torch.vtensor<[1,53,56,128],f32>, !torch.vtensor<[1,3,56,128],f32>) -> !torch.list<vtensor>
    %int1 = torch.constant.int 1
    %29 = torch.aten.cat %28, %int1 : !torch.list<vtensor>, !torch.int -> !torch.vtensor<[1,56,56,128],f32>
    return %29 : !torch.vtensor<[1,56,56,128],f32>
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

