from trash_type import *
import urllib.request
from pathlib import Path
import random
import json
from PIL import Image
from resizeimage import resizeimage
from watson_developer_cloud import VisualRecognitionV3

visual_recognition = VisualRecognitionV3(
    '2020-02-09',
    iam_apikey='lfGJ9tvqtv9maRFfttyM61wGcrGIYD88zsY_Yq4ZdQWI'
)

def download(url, filename):
    Path("temp").mkdir(parents=True, exist_ok=True)
    urllib.request.urlretrieve(url, filename)

def process(filename):
    with open(filename, 'r+b') as f:
        classes = visual_recognition.classify(
            f,
            threshold='0.6',
	        classifier_ids='WasteClassifier_1615383111').get_result()
            

    print(json.dumps(classes, indent=2))
    return classes["images"][0]["classifiers"][0]["classes"][0]["class"]
