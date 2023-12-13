import Foundation

final class BarcodeScanner { // возвращает имя товара
        
    // получает HTML-страницу и возвращает название товара или ""
    static func getNameOfProduct(_ HTMLPage: String?) -> String {
        guard let loadedHTMLPage = HTMLPage else {return ""} // если страница не загружена - вместо имени товара возвращаем ""
        if loadedHTMLPage.components(separatedBy: "<meta name=\"description\" content=\"\" >").count > 1 { // если штрих-кода товара нет на сайте
            return ""
        } else {
            // на сайте различные товары могут отображаться по разному - у некоторых название находится в центре страницы, у некоторых же - слева
            // в завимости от этого будет пробовать определить название товара для обоих случаев
                var arrayOfDelimiters : [(delimiter1: String, delimiter2: String, delimiter3: String)] = []
            // массив дает возможность дополнять другими функцию другими разделителями для поиска (при необходимости)
                arrayOfDelimiters.append(("<h1 class=\"pageTitle\" style=\"text-align: center \" >",
                                          "<p style=\"margin-top:20px; text-align: center \">Результаты поиска <b>",
                                          "Штрих-код:")) // поиск для товаров, у которых наименование указано в центре страницы
                                                         // таких товаров, кажется, больше,
                                                         // поэтому соответствующие разделители в формате тюпла будут в массиве под индексом 0
                arrayOfDelimiters.append(("<h1 class=\"pageTitle\" style=\"text-align: left \" >",
                                          "<p style=\"margin-top:20px; text-align: left \">Результаты поиска",
                                          "Штрих-код:")) // поиск для товаров, у которых наименование указано слева
                                                         // таких товаров, кажется, меньше
                                                         // поэтому соответствующие разделители в формате тюпла будут в массиве под индексом 1
                // итерация по массиву разделителей
                for element in arrayOfDelimiters {
                    var myPageParts: [String] = loadedHTMLPage.components(separatedBy: element.delimiter1)
                    if (myPageParts.count == 2){ // если соответствующий разделитель режет страницу на две части, начинаем, поиск имени товара
                        var nameOfProduct = myPageParts[1]
                        //print("nameOfProduct = \(nameOfProduct)")
                        myPageParts = nameOfProduct.components(separatedBy: element.delimiter2)
                        nameOfProduct = myPageParts[0] // отрезаем от названия конец
                        //print("nameOfProduct = \(nameOfProduct)")
                        myPageParts = nameOfProduct.components(separatedBy: element.delimiter3)
                        nameOfProduct = myPageParts[0] // оставляем только начало продукта, однако в конце остаются еще пробелы и тире
                        //print("nameOfProduct = \(nameOfProduct)")
                        nameOfProduct = String(nameOfProduct[...nameOfProduct.index(nameOfProduct.endIndex, offsetBy: -3)]) // отрезаем пробелы и тире
                        return nameOfProduct
                    } // иначе начинаем поиск по другим разделителям
                    continue
                }
                return ""
            }
    }
}
