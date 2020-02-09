from trash_type import *
import urllib.request
from pathlib import Path

def download(url, filename):
    Path("temp").mkdir(parents=True, exist_ok=True)
    urllib.request.urlretrieve(url, filename)

def process(filename):
    return PLASTIC
