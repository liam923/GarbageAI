from trash_type import *
import urllib.request
from pathlib import Path
import random
import json
import requests
import base64

url = "https://automl.googleapis.com/v1beta1/projects/610553338848/locations/us-central1/models/ICN3385523845271126016:predict"
token = "ya29.c.Ko8BvQfx3l8RY4Sunvt4DaH0oqaeRXZBlAGUFedHWrGsPiGkwEE2BVaoNpsn-AASrmSXQy7hr4yagjsqpqUsfL390RBtwdEBP__GMJB70IPBO6NpVZAW5nc_b7zb6krhvg0gxIGIng4Rcc7wZ5LIymmzQYC8SREKANHhiDr6LsXFEzCXH2UuCzYFjFmt6kCuTSM"

def download(url, filename):
    Path("temp").mkdir(parents=True, exist_ok=True)
    urllib.request.urlretrieve(url, filename)

def process(filename):
    with open(filename, 'rb') as ff:
        content = ff.read()

        body = json.dumps({'payload': {'image': {'image_bytes': base64.b64encode(content).decode('ascii') }}})
        r = requests.post(url, data=body, headers={"Authorization": "Bearer %s" % token})
        print(r.text)

        j = r.json()
        if 'payload' in j and len(j['payload']) > 0 and 'displayName' in j['payload'][0]:
            return r.json()['payload'][0]['displayName']
        else:
            return TRASH
