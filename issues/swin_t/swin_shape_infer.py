import argparse
import onnx
from onnx import helper, shape_inference
from onnx import TensorProto
from onnx.onnx_pb import ModelProto

parser = argparse.ArgumentParser()
parser.add_argument("i", type=str, help="in")
parser.add_argument("o", type=str, help="out")
parser.add_argument("--clear", action="store_true", help="clear before infer")

args = parser.parse_args()

# args = [
#     "demos/swin-transform.onnx.opset13.onnx.sim.onnx.opt.onnx",
#     "demos/swin-transform.onnx.opset13.onnx.sim.onnx.opt.onnx.shape.onnx",
#     # "test/python/onnx_importer/LeakyReLU.onnx",
#     # "test/python/onnx_importer/LeakyReLU.onnx.shape.onnx",
#     "--clear",
# ]
# args = parser.parse_args(args)
# print(f"args.clear: {args.clear}")

original_model = onnx.load_model(args.i)
# original_model: ModelProto

if args.clear:
    vi = original_model.graph.value_info
    for i in range(len(vi)):
        vi.pop()

inferred_model = shape_inference.infer_shapes(original_model)
onnx.save_model(inferred_model, args.o)
