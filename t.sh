git submodule init
git submodule update --init --depth=1 externals/stablehlo

# optional: do not sync llvm-project(using pre-built llvm)
git submodule deinit -f externals/llvm-project

# optional: softlink llvm-project

# sync llvm-project
git submodule update --recursive --depth=1

# tmp
# git submodule add https://github.com/llvm/llvm-project.git externals/llvm-project

# -----
# softlink llvm-project

# clone once
pushd ..
git clone https://github.com/llvm/llvm-project.git
popd

TAG="bb180856ec28efe305dc77ca4bb3db12d8932edf"
mkdir llvm-project-$TAG
pushd llvm-project-$TAG
git init
git remote add origin ../../llvm-project
git fetch --depth 1 origin $TAG
git checkout FETCH_HEAD
git remote set-url origin https://github.com/llvm/llvm-project.git
popd

# replace with local repo
rm -rf $PWD/externals/llvm-project
ln -sf $PWD/llvm-project-$TAG $PWD/externals/llvm-project

# -----

# cat >>~/.zshrc <<-EOF
cat >>~/.bashrc <<-EOF
export PATH=\$PATH:\${EXT_PATH}
export PYTHONPATH=\$PYTHONPATH:\${EXT_PYTHONPATH}
EOF

# -----

# debug

torch-mlir-opt --help >_demos/torch-mlir-opt.help.log

python -m torch_mlir.tools.import_onnx test/python/onnx_importer/LeakyReLU.onnx -o _demos/test.onnx.mlir
torch-mlir-opt \
  --convert-torch-onnx-to-torch \
  -o _demos/torch.test.onnx.mlir \
  _demos/test.onnx.mlir
