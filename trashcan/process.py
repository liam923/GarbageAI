from trash_type import *
import urllib.request
from pathlib import Path
import random
import json
import requests
import base64

url = "https://automl.googleapis.com/v1beta1/projects/610553338848/locations/us-central1/models/ICN3385523845271126016:predict"
token = "ya29.c.Ko8BvQc_uuPPIaP-Aqop_ZOh2rClDCxDRnfByjL_I_MU9HKiEhRcghu4WkP_FxC2103-3_LxgKi_AVWPEX7yCb8QgHS8ZkaEReWBXFBzw0LNbwaV9WSGu8ujQUopdkfQ0ZN-bvo9lt6ZUEt3gNiPsGWNOlvhhGa0gwSjoGm6dtaGlXbqCDHe1QH4B3GcfrYAGBY"

def download(url, filename):
    Path("temp").mkdir(parents=True, exist_ok=True)
    urllib.request.urlretrieve(url, filename)

def process(filename):
    with open(filename, 'rb') as ff:
        content = ff.read()

        body = json.dumps({'payload': {'image': {'image_bytes': base64.b64encode(content).decode('ascii') }}})
        r = requests.post(url, data=body, headers={"Authorization": "Bearer %s" % token})
        print(r.text)

        return r.json()['payload'][0]['displayName']  # waits till request is returned
