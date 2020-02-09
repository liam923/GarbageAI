from trashcan import Trashcan
import sys
import process

def completion_handler(trashcan, doc):
    data = doc.to_dict()
    process.download(data[u'url'], 'temp/image.jpg')
    trash_type = process.process('temp/image.jpg')
    trashcan.handle_trash(trash_type)
    trashcan.generate_qr_code(doc.id, trash_type, 'temp/qr.png')

def main(trashcanID):
    trashcan = Trashcan(trashcanID)
    trashcan.listen(lambda d: completion_handler(trashcan, d))
    while True:
        pass

if __name__ == '__main__':
    main(sys.argv[1])
