import onnx
import argparse
from onnx import version_converter

parser = argparse.ArgumentParser()
parser.add_argument("i", type=str, help="in")
parser.add_argument("o", type=str, help="out")
parser.add_argument("--opset", type=int, help="out opset")
args = parser.parse_args()

original_model = onnx.load(args.i)
converted_model = version_converter.convert_version(original_model, args.opset)
onnx.save_model(converted_model, args.o)
