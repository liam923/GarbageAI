from trashcan import Trashcan
import sys
import process
from guizero import App, Text

class Main():
    def __init__(self, trashcanID):
        self.trashcan = Trashcan(trashcanID)
        self.app = App(title="GarbageAI")

        self.stats_widget = Text(self.app, "")
        self.update_stats()

        self.trashcan.listen(self.completion_handler)
        self.app.display()

    def update_stats(self):
        self.stats_widget.clear()
        self.stats_widget.append("\n".join(["%s: %s" % i for i in self.trashcan.stats.items()]))

    def completion_handler(self, doc):
        data = doc.to_dict()
        process.download(data[u'url'], 'temp/image.jpg')
        trash_type = process.process('temp/image.jpg')
        self.trashcan.handle_trash(trash_type)
        self.update_stats()
        self.trashcan.generate_qr_code(doc.id, trash_type, 'temp/qr.png')

if __name__ == '__main__':
    Main(sys.argv[1])
