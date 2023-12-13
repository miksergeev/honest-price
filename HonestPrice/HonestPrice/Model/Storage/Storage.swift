import Foundation

final class Storage {
    // ссылка на хранилище
    private var storage = UserDefaults.standard
    // ключ, по которому будет происходить сохранение хранилища
    private var storageKey = "shoppingList"
    
    // перечисление с ключами для записи
    private enum ProductKey: String {
        case nameOfProduct
        case honestPrice
    }
    
    func load() -> [ProductShoppingListStruct] {
        var resultProducts : [ProductShoppingListStruct] = []
        let productsFromStorage = storage.array(forKey: storageKey) as? [[String:String]] ?? []
        //print("productsFromStorage: \(productsFromStorage)")
        for product in productsFromStorage {
            guard let nameOfProduct = product[ProductKey.nameOfProduct.rawValue],
                  let honestPrice = product[ProductKey.honestPrice.rawValue]
            else {
                continue
            }
            resultProducts.append(ProductShoppingListStruct(productName: nameOfProduct, honestPrice: honestPrice))
        }
        //print("resultProducts: \(resultProducts)")
        return resultProducts
    }
    
    func save(products: [ProductShoppingListStruct]) {
        var productsForStorage: [[String:String]] = []
        products.forEach { product in
            var newElementForStorage: Dictionary<String, String> = [:]
            newElementForStorage[ProductKey.nameOfProduct.rawValue] = product.productName
            newElementForStorage[ProductKey.honestPrice.rawValue] = product.honestPrice
            productsForStorage.append(newElementForStorage)
        }
        storage.set(productsForStorage, forKey: storageKey)
    }
}
