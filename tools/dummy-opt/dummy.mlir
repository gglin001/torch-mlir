module attributes {} {
  func.func @forward(%arg0: !torch.vtensor<[1,3,224,224],f32>) -> !torch.vtensor<[1,3,224,224],f32> {
    %none = torch.constant.none
    return %arg0 : !torch.vtensor<[1,3,224,224],f32>
  }
}
