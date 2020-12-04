import os, sys
from struct import unpack, pack
import numpy as np
import cv2
import cvlib as cv
import json

UUID4_SIZE = 16

def setup_io():
    return os.fdopen(3,"rb"), os.fdopen(4,"wb")

def read_message(input_f):
    header = input_f.read(4)
    if len(header) != 4: 
        return None
    (total_msg_size,) = unpack("!I", header)
    image_id = input_f.read(UUID4_SIZE)
    image_data = input_f.read(total_msg_size - UUID4_SIZE)
    nparr = np.fromstring(image_data, np.uint8)
    image = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

    return {'id': image_id, 'image': image}

def detect(image, model):
    boxes, labels, _conf = cv.detect_common_objects(image, model=model)
    return boxes, labels

def write_result(output, image_id, image_shape, boxes, labels):
    result = json.dumps({
        'shape': image_shape,
        'boxes': boxes, 
        'labels': labels
    }).encode("ascii")

    header = pack("!I", len(result) + UUID4_SIZE)
    output.write(header)
    output.write(image_id)
    output.write(result)
    output.flush()


def run(model):
    input_f, output_f = setup_io()
    while True:
        msg = read_message(input_f)
        if msg is None: break
        print(msg["image"])
        height, width, _ = msg["image"].shape
        shape = {'width': width, 'height': height}
        boxes, labels = detect(msg["image"], model)
        write_result(output_f, msg["id"], shape, boxes, labels)

if __name__ == "__main__":
    model = "yolov3"
    if len(sys.argv) > 1: 
        model = sys.argv[1]
    
    run(model)
