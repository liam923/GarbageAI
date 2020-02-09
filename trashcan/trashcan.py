import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import qrcode
import json
from datetime import datetime
from trash_type import get_direction
import requests

default_app = firebase_admin.initialize_app()
db = firestore.client()

API_ENDPOINT = "https://happening-prairiedog-9299.dataplicity.io/open"

class Trashcan:
    def __init__(self, trashcanID):
        self.trashcanID = trashcanID
        self.trash = db.collection(u'trashcans').document(self.trashcanID).collection("trash")
        self.stats = {}

        self.latitude = 42.3508
        self.longitude = -71.0469

    def listen(self, callback):
        seen_trash = set()

        initial = [True]
        def on_snapshot(col_snapshot, changes, read_time):
            for doc in col_snapshot:
                d = doc.to_dict()
                if doc.id not in seen_trash:
                    seen_trash.add(doc.id)
                    if not initial[0]:
                        callback(doc)
            initial[0] = False

        query = self.trash.where(u'time', u'>', datetime.now())
        query_watch = query.on_snapshot(on_snapshot)

    def generate_qr_code(self, trash_id, trash_type, filename):
        data = json.dumps({"trashType": trash_type, "trashID": trash_id, "trashcanID": self.trashcanID, "latitude": self.latitude, "longitude": self.longitude, "trashcanCounts": self.stats})
        qr = qrcode.QRCode(
            version=1,
            error_correction=qrcode.constants.ERROR_CORRECT_L,
            box_size=10,
            border=4,
        )

        qr.add_data(data)
        qr.make(fit=True)

        img = qr.make_image(fill_color="white", back_color="#124850")
        img.save(filename)

    def handle_trash(self, trash_type):
        if trash_type in self.stats:
            self.stats[trash_type] += 1
        else:
            self.stats[trash_type] = 1

        requests.post(url = API_ENDPOINT, params={"direction": get_direction(trash_type)}, headers={"Authorization": "Bearer e0JcwTdkI2ULFLJeQ220httVa9uJRhIT"})
