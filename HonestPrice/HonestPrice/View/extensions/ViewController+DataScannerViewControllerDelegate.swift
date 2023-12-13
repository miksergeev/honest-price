import VisionKit

extension ViewController: DataScannerViewControllerDelegate {
    func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
        for item in addedItems {
            switch item {
            case .barcode(let barcode):
                barCodeField.text = barcode.payloadStringValue
                dataScanner.stopScanning()
                dataScanner.dismiss(animated: true)
                findProduct()
                break
                default: break
            }
        }
    }
}
