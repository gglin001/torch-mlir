module {
  func.func @main(%arg0: !torch.vtensor<[1,56,56,128],f32>) -> !torch.vtensor<[1,56,56,128],f32> {
    %int0 = torch.constant.int 0
    %int0_0 = torch.constant.int 0
    %int9223372036854775807 = torch.constant.int 9223372036854775807
    %int1 = torch.constant.int 1
    %0 = torch.aten.slice.Tensor %arg0, %int0, %int0_0, %int9223372036854775807, %int1 : !torch.vtensor<[1,56,56,128],f32>, !torch.int, !torch.int, !torch.int, !torch.int -> !torch.vtensor<[1,56,56,128],f32>
    %int1_1 = torch.constant.int 1
    %int3 = torch.constant.int 3
    %int9223372036854775807_2 = torch.constant.int 9223372036854775807
    %int1_3 = torch.constant.int 1
    %1 = torch.aten.slice.Tensor %0, %int1_1, %int3, %int9223372036854775807_2, %int1_3 : !torch.vtensor<[1,56,56,128],f32>, !torch.int, !torch.int, !torch.int, !torch.int -> !torch.vtensor<[1,53,56,128],f32>
    %int2 = torch.constant.int 2
    %int0_4 = torch.constant.int 0
    %int9223372036854775807_5 = torch.constant.int 9223372036854775807
    %int1_6 = torch.constant.int 1
    %2 = torch.aten.slice.Tensor %1, %int2, %int0_4, %int9223372036854775807_5, %int1_6 : !torch.vtensor<[1,53,56,128],f32>, !torch.int, !torch.int, !torch.int, !torch.int -> !torch.vtensor<[1,53,56,128],f32>
    %int3_7 = torch.constant.int 3
    %int0_8 = torch.constant.int 0
    %int9223372036854775807_9 = torch.constant.int 9223372036854775807
    %int1_10 = torch.constant.int 1
    %3 = torch.aten.slice.Tensor %2, %int3_7, %int0_8, %int9223372036854775807_9, %int1_10 : !torch.vtensor<[1,53,56,128],f32>, !torch.int, !torch.int, !torch.int, !torch.int -> !torch.vtensor<[1,53,56,128],f32>
    %int0_11 = torch.constant.int 0
    %int0_12 = torch.constant.int 0
    %int9223372036854775807_13 = torch.constant.int 9223372036854775807
    %int1_14 = torch.constant.int 1
    %4 = torch.aten.slice.Tensor %arg0, %int0_11, %int0_12, %int9223372036854775807_13, %int1_14 : !torch.vtensor<[1,56,56,128],f32>, !torch.int, !torch.int, !torch.int, !torch.int -> !torch.vtensor<[1,56,56,128],f32>
    %int1_15 = torch.constant.int 1
    %int0_16 = torch.constant.int 0
    %int3_17 = torch.constant.int 3
    %int1_18 = torch.constant.int 1
    %5 = torch.aten.slice.Tensor %4, %int1_15, %int0_16, %int3_17, %int1_18 : !torch.vtensor<[1,56,56,128],f32>, !torch.int, !torch.int, !torch.int, !torch.int -> !torch.vtensor<[1,3,56,128],f32>
    %int2_19 = torch.constant.int 2
    %int0_20 = torch.constant.int 0
    %int9223372036854775807_21 = torch.constant.int 9223372036854775807
    %int1_22 = torch.constant.int 1
    %6 = torch.aten.slice.Tensor %5, %int2_19, %int0_20, %int9223372036854775807_21, %int1_22 : !torch.vtensor<[1,3,56,128],f32>, !torch.int, !torch.int, !torch.int, !torch.int -> !torch.vtensor<[1,3,56,128],f32>
    %int3_23 = torch.constant.int 3
    %int0_24 = torch.constant.int 0
    %int9223372036854775807_25 = torch.constant.int 9223372036854775807
    %int1_26 = torch.constant.int 1
    %7 = torch.aten.slice.Tensor %6, %int3_23, %int0_24, %int9223372036854775807_25, %int1_26 : !torch.vtensor<[1,3,56,128],f32>, !torch.int, !torch.int, !torch.int, !torch.int -> !torch.vtensor<[1,3,56,128],f32>
    %8 = torch.prim.ListConstruct %3, %7 : (!torch.vtensor<[1,53,56,128],f32>, !torch.vtensor<[1,3,56,128],f32>) -> !torch.list<vtensor>
    %int1_27 = torch.constant.int 1
    %9 = torch.aten.cat %8, %int1_27 : !torch.list<vtensor>, !torch.int -> !torch.vtensor<[1,56,56,128],f32>
    return %9 : !torch.vtensor<[1,56,56,128],f32>
  }
}
