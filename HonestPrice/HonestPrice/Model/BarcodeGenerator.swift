import Foundation
import UIKit

// данный генератор создает изображение штрих-кода стандарта Code-128
// для большинства товаров используется код стандарта EAN13
// изображение штрих-кода генерируется исключительно в качестве элемента дизайна
final class BarcodeGenerator {
    static func generateBarcode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                print(UIImage(ciImage: output).size)
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
}
