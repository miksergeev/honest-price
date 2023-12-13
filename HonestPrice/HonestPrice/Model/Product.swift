class Product { // класс "товар" // имеет следующие поля,
    var nameOfProduct: String = "" // название товара
    
    var typeOfPackageForOneItem: TypesOfPackages? // тип единиц за упаковку
    var quantityForOneItem: Double? // количество товара в единице (упаковке)
    var priceForOneItem: Double? // цена за одну упаковку
    
    var honestTypeOfPackage: TypesOfPackages? { // универсальный тип упаковки
        guard let typeOfPackage = typeOfPackageForOneItem else { return nil }
        switch typeOfPackage {
            case .g, .kg: return .kg
            case .ml, .l: return .l
            case .pcs:    return .pcs
        }
    }
    var honestPrice: Double? { // честная цена
        guard let price = priceForOneItem, let quantity = quantityForOneItem, let package = typeOfPackageForOneItem else { return nil }
        if (price == 0) { return 0} 
        else {
            switch package {
            case .g:    return (price / quantity) * 1000
            case .kg:   return (price / quantity)
            case .ml:   return (price / quantity) * 1000
            case .l:    return (price / quantity)
            case .pcs:  return (price / quantity)
            }
        }
    }
}


