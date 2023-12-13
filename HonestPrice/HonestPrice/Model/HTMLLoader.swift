import Foundation

final class HTMLLoader { // загружает HTML-страницу с заданным баркодом
    var barcodeNumber: String = "" // баркод
    var htmlPage: String? = nil // HTML-страница
    init(barcodeNumber: String = "", htmlPage: String? = nil) async {
        self.barcodeNumber = barcodeNumber
        self.htmlPage = await HTMLLoader.printData(barcodeNumber)
    }
    
    static func fetchData(_ barcode: String = "") async throws -> String? {
        guard let barcodeUInt64 = UInt64(barcode) else {return nil}
            if let url = URL(string: "https://barcode-list.ru/barcode/RU/Поиск.htm?barcode=\(barcodeUInt64)") {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    let page = String(decoding: data, as: UTF8.self)
                    return page
                }
            } else {
                return nil
            }
    }

    static func printData(_ barcode: String) async -> String? {
      do {
          _ = try await fetchData(barcode)
          return nil
        //print(String(data: data, encoding: .utf8)!)
      } catch {
          return nil
        //print("Error: \(error)")
      }
    }

    
    
    
    
}

