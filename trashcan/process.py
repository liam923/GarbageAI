from trash_type import *
import urllib.request
from pathlib import Path
import random
from PIL import Image
from resizeimage import resizeimage

def download(url, filename):
    Path("temp").mkdir(parents=True, exist_ok=True)
    urllib.request.urlretrieve(url, filename)

def process(filename):
    with open(filename, 'r+b') as f:
        with Image.open(f) as image:
            cover = resizeimage.resize_cover(image, [384, 512]).save(filename, image.format)
    return random.choice(all)
