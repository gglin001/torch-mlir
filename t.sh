git submodule init
git submodule update --init --depth=1 externals/stablehlo

# git submodule update --init --depth=1
# optional: softlink llvm-project

# clone once
pushd ..
git clone https://github.com/llvm/llvm-project.git
popd

TAG="6b65d79fbb4682468333cea42b62f15c2dffd8f3"
mkdir llvm-project-$TAG
pushd llvm-project-$TAG
git init
git remote add origin ../../llvm-project
git fetch --depth 1 origin $TAG
git checkout FETCH_HEAD
git remote set-url origin https://github.com/shark-infra/llvm-project.git
popd

# replace with local repo
rm -rf $PWD/externals/llvm-project
ln -sf $PWD/llvm-project-$TAG $PWD/externals/llvm-project
git add externals/llvm-project

torch-mlir-opt --help >demos/torch-mlir-opt.help.log

python -m torch_mlir.tools.import_onnx test/python/onnx_importer/LeakyReLU.onnx -o demos/test.onnx.mlir
torch-mlir-opt \
    --convert-torch-onnx-to-torch \
    -o demos/torch.test.onnx.mlir \
    demos/test.onnx.mlir
