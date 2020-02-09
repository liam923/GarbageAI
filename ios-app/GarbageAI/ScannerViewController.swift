// Taken from https://www.hackingwithswift.com/example-code/media/how-to-scan-a-qr-code

import AVFoundation
import UIKit
import CodeScanner

class ScannerViewController: UIViewController {

    private var scanner: CodeScanner!

    override func viewDidLoad() {

        super.viewDidLoad()

        self.navigationItem.title = "Detect QR code from Camera"
        self.view.backgroundColor = .groupTableViewBackground

        self.scanner = CodeScanner(metadataObjectTypes: [AVMetadataObject.ObjectType.qr], preview: self.view)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        CodeScanner.requestCameraPermission { (success) in
            if success {
                self.scanner.scan(resultOutputs: { (outputs) in
                    print(outputs)
                })
            }
        }
    }

    func found(code: String) {
        let jsonData = code.data(using: .utf8) ?? Data()
        Database.shared.record(trash: try! JSONDecoder().decode(QRData.self, from: jsonData))
        self.navigationController?.popViewController(animated: true)
    }
}
