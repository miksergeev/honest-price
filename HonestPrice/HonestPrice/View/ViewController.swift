import UIKit
import VisionKit

class ViewController: UIViewController, UITextFieldDelegate {
    // хранение данных
    var storage = Storage()
    // продукт
    var myProduct = Product()
    // список товаров
    var shoppingList : [ProductShoppingListStruct] = []
    
    private func loadShoppingList() {
        shoppingList = storage.load()
    }
    
    @IBOutlet var barCodeImageView: UIImageView!
    @IBOutlet var barCodeField: UITextField!
    @IBOutlet var productNameTextView: UITextView!
    @IBOutlet var priceForItem: UITextField!
    @IBOutlet var quantityForItem: UITextField!
    @IBOutlet var pickerViewForItem: UIPickerView!
    @IBOutlet var honestPriceLabel: UILabel!
    @IBOutlet var honestPriceLabelLineTwo: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        shoppingList = storage.load() // загружаем список из хранения
        
        pickerViewForItem.dataSource = self
        pickerViewForItem.delegate = self
        barCodeField.delegate = self
        priceForItem.delegate = self
        quantityForItem.delegate = self
    
        becomeFirstResponder()
    }
    

    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // сканированию по жесту 'shake'
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            startScanningPressed()
        }
    }
    
    @IBAction func findProduct() { // если новый баркод не нашелся - затереть все старые поля
        Task { @MainActor in
            guard let inputBarcode = barCodeField.text else { return }// если баркод не введен, ничего не происходит
            barCodeImageView.image = BarcodeGenerator.generateBarcode(from: inputBarcode)
            let htmlPage = try await HTMLLoader.fetchData(inputBarcode) // загрузка страницы
            guard let htmlPageIsLoaded = htmlPage else {
                productNameTextView.text = ""
                priceForItem.text = ""
                quantityForItem.text = ""
                honestPriceLabel.text = ""
                return
            } // если не загрузилась - выход из функции
            
            myProduct.nameOfProduct = BarcodeScanner.getNameOfProduct(htmlPageIsLoaded) // ищем имя продукта
            guard myProduct.nameOfProduct != "" else { 
                productNameTextView.text = ""
                priceForItem.text = ""
                quantityForItem.text = ""
                honestPriceLabel.text = ""
                return } // если не нашлось - выход из функции
            
            
            productNameTextView.text = myProduct.nameOfProduct // текстовой метке присваивается имя продукта
            // пробуем по имени продукта найти единицы измерения и количество, если не нашлось - выход из функции
            guard let currentTypeOfPackage = PackageQuantityParser.getPackageAndQuantity(nameOfProduct: myProduct.nameOfProduct) else {
                priceForItem.text = ""
                quantityForItem.text = ""
                honestPriceLabel.text = ""
                return }
            myProduct.typeOfPackageForOneItem = currentTypeOfPackage.0
            myProduct.quantityForOneItem = currentTypeOfPackage.1
            quantityForItem.text = String(format: "%g", myProduct.quantityForOneItem!) // текстовой метке присваивается количество таких единиц (например, 20 МЛ или 100 МЛ)

            switch myProduct.typeOfPackageForOneItem { // в PickerView подставляется подходящая единица измерения (например, МЛ или КГ)
                case .ml: pickerViewForItem.selectRow(0, inComponent: 0, animated: false)
                case .g: pickerViewForItem.selectRow(1, inComponent: 0, animated: false)
                case .l: pickerViewForItem.selectRow(2, inComponent: 0, animated: false)
                case .kg: pickerViewForItem.selectRow(3, inComponent: 0, animated: false)
                case .pcs: pickerViewForItem.selectRow(4, inComponent: 0, animated: false)
                default: break
            }
        }
    }

    @IBAction func calculateHonestPrice() {
        guard let price = Double(priceForItem.text!.replacingOccurrences(of: ",", with: ".")) // decimal клавиатура заставляет менять запятые на точки
        else {
            return
        } // цена за единицу товара из введенного поля, если цена не введена - ничего не происходит
        myProduct.priceForOneItem = price
        guard let quantity = Double(quantityForItem.text!.replacingOccurrences(of: ",", with: ".")) // decimal клавиатура заставляет менять запятые на точки
        else {
            return
        } // количество единиц товара из введенного поля если не введено - ничего не происходит
        myProduct.quantityForOneItem = quantity
        
        switch pickerViewForItem.selectedRow(inComponent: 0) {
            case 0: myProduct.typeOfPackageForOneItem = .ml
            case 1: myProduct.typeOfPackageForOneItem = .g
            case 2: myProduct.typeOfPackageForOneItem = .l
            case 3: myProduct.typeOfPackageForOneItem = .kg
            case 4: myProduct.typeOfPackageForOneItem = .pcs
            default: break
        }
        
        // прописываем честную цену
        var unitOfProduct : String = "" // универсальная мера - КГ/Л/ШТ
        switch myProduct.honestTypeOfPackage {
            case .kg: unitOfProduct = "КГ"
            case .l: unitOfProduct = "Л"
            case .pcs: unitOfProduct = "ШТ"
            default: unitOfProduct = ""
        }
        
        honestPriceLabel.text = "\(String(format: "%.2f", myProduct.honestPrice ?? 0))" // честная цена - в формате с двумя знаками после запятой
        honestPriceLabelLineTwo.text = " рублей / \(unitOfProduct)"
    }
    
    @IBAction func startScanningPressed() {
        guard DataScannerViewController.isAvailable == true, DataScannerViewController.isSupported == true else {
            return
        }
        
        let dataScanner = DataScannerViewController(recognizedDataTypes: [.barcode()], isHighlightingEnabled: true)
        dataScanner.delegate = self
        present(dataScanner, animated: true) {
            try? dataScanner.startScanning()
        }
    }
    
    @IBAction func saveToShoppingList() {
        guard productNameTextView.text != "",
              myProduct.honestPrice != nil
        else {
            return
        }
        myProduct.nameOfProduct = productNameTextView.text
        myProduct.priceForOneItem = Double(priceForItem.text ?? "0")
        loadShoppingList()
        shoppingList.append(ProductShoppingListStruct(productName: productNameTextView.text, honestPrice: String(format: "%.2f", myProduct.honestPrice!)))
        storage.save(products: shoppingList)
    }

    // hiding keyboard when touching outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // hiding keyboard when pressing 'return'
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


