from trashcan import Trashcan
from trash_type import all as all_trash_types, pretty
import sys
import process
from guizero import App, Text, Picture

class Main():
    def __init__(self, trashcanID):
        self.trashcan = Trashcan(trashcanID)
        self.app = App(title="GarbageAI")

        self.stats_widget = Text(self.app, "")
        self.update_stats()

        self.detected_widget = Text(self.app, "")

        self.display_qr(None)

        self.trashcan.listen(self.completion_handler)
        self.app.display()

    def update_stats(self):
        self.stats_widget.clear()
        arr = ["%s: %s" % (pretty(k), v) for k, v in self.trashcan.stats.items()]
        self.stats_widget.append("\n".join(arr + [""] * (len(all_trash_types) - len(arr))))

    def completion_handler(self, doc):
        data = doc.to_dict()
        process.download(data[u'url'], 'temp/image.jpg')
        trash_type = process.process('temp/image.jpg')
        self.trashcan.handle_trash(trash_type)
        self.update_stats()
        self.trashcan.generate_qr_code(doc.id, trash_type, 'temp/qr.png')
        self.display_qr(trash_type)

    def display_qr(self, trash_type):
        if hasattr(self, 'qr_widget'):
            self.qr_widget.destroy()
        self.detected_widget.clear()
        if trash_type is not None:
            self.detected_widget.append("Detected %s" % trash_type)
            self.qr_widget = Picture(self.app, "temp/qr.png")

if __name__ == '__main__':
    Main(sys.argv[1])
