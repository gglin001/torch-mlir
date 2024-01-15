import argparse
import onnx
from onnx import helper, shape_inference
from onnx import TensorProto
from onnx.onnx_pb import ModelProto
from onnx import numpy_helper as nph
import numpy as np

parser = argparse.ArgumentParser()
parser.add_argument("i", type=str, help="in")
parser.add_argument("o", type=str, help="out")

args = parser.parse_args()
# args = [
#     "demos/swin-transform.onnx.opset14.onnx.sim.onnx.opt.onnx.shape.onnx",
#     "demos/swin-transform.onnx.opset14.onnx.sim.onnx.opt.onnx.shape.onnx.slice.onnx",
# ]
# args = parser.parse_args(args)

original_model = onnx.load_model(args.i)
# original_model: ModelProto


# def func(node):
#     if node.op_type == "Slice":
#         print()
#         if len(node.input) == 4:
#             # steps =
#             node.input.append()


graph = original_model.graph
idx = 0
for node in graph.node:
    # func(node)
    if node.op_type == "Slice" and len(node.input) == 4:
        steps = np.array([1], dtype=int)
        steps_weight_name = f"Slice_opt_steps_{idx}"
        graph.initializer.extend([nph.from_array(steps, name=steps_weight_name)])
        node.input.append(steps_weight_name)


onnx.save_model(original_model, args.o)
