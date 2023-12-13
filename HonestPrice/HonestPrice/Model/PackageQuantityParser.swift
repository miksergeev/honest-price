import Foundation

final class PackageQuantityParser {
    // следующая функция парсит единицу измерения товара и количество в формате тюпла (единица измерения, количество) - например, (.l, 1.5) или (.g, 400).
    // если что-то из этого не находит - возвращается nil
    static func getPackageAndQuantity(nameOfProduct: String) -> (TypesOfPackages, Double)? {
        let nameOfProductUppercased = nameOfProduct.uppercased() // имя переводится в верхний регистр
        // ищем единицу измерения
        // сначала находим в строке ключевые слова "Г", "КГ", "МЛ", "Л", "ШТ"
        let arrayForMeasurements = ["Г", "КГ", "МЛ", "Л", "ШТ", "G", "GR", "KG", "ML", "L"] // массив, содержащий ключевые слова
        var arrayForFoundMeasurements: [String:Int] = [:] // словарь для найденных меток в конкретном продукте, туда будут собираться все метки "Г, КГ...", которые нашлись в имени товара [КГ:2], если буквосочетание "КГ" встречалось в тексте два раза
        for element in arrayForMeasurements {
            if (nameOfProductUppercased.components(separatedBy: element).count > 1) { // если такая метка была не в начале и не в конце - она попадает в массив
                    arrayForFoundMeasurements[element] = nameOfProductUppercased.components(separatedBy: element).count - 1
            }
        }
        // затем ищем такую единицу измерения, перед которой стоит число
        var currentNumberForOutputString: String // это число граммов/килограммов и так далее, которое ищется в строке с названием продукта
        outerCycle: for element in arrayForFoundMeasurements {
            currentNumberForOutputString = "" // здесь обрабатывается каждая метка для продукта и ищется число
            for i in (0 ..< (arrayForFoundMeasurements[element.key] ?? 0)) {
                // вот таких кусков - currentSubWord - может быть несколько
                // здесь надо задавать currentSubWord в зависимости от количества
                let currentSubWord = nameOfProductUppercased.components(separatedBy: element.key)[i] // текущее "подслово"
                if (currentSubWord.count > 0) { // иногда название товара начинается например, с буквы "Л" или "Г" или буквосочетания "гр" и так далее
                    // это обработка куска
                    for i in (1...currentSubWord.count) { // здесь обрабатывается каждый кусок, разделенный меткой
                        if (String(currentSubWord[currentSubWord.index(currentSubWord.endIndex, offsetBy: -i)]) == " ") { // если после единицы измерения стоит пробел, идем к следующему символу влево
                            // но если после пробела стоит цифра, то идем на вывод - потому что есть названия вроде "Молоко Липецкое 3,2 1л"
                            // если не выйти - функция распознает количество как 3.21
                            if ((1-i) < 0) && (Int(String(currentSubWord[currentSubWord.index(currentSubWord.endIndex, offsetBy: -i+1)])) != nil) {
                                break
                            } else {
                                continue
                            }
                        }
                        if Int(String(currentSubWord[currentSubWord.index(currentSubWord.endIndex, offsetBy: -i)])) != nil { // если цифра - добавляем
                            currentNumberForOutputString.insert(Character(extendedGraphemeClusterLiteral: currentSubWord[currentSubWord.index(currentSubWord.endIndex, offsetBy: -i)]), at: currentNumberForOutputString.startIndex)
                        } else {
                            if (String(currentSubWord[currentSubWord.index(currentSubWord.endIndex, offsetBy: -i)]) == "," || // если запятая или точка
                                String(currentSubWord[currentSubWord.index(currentSubWord.endIndex, offsetBy: -i)]) == ".") { // добавляем как точку для последующей конвертации в Double
                                currentNumberForOutputString.insert(Character("."), at: currentNumberForOutputString.startIndex)
                            } else {
                                break
                            }
                        }
                    }
                } else {
                    continue
                }
            }
            // возможны ситуации, когда количество равняется ".95". Тогда приведение к Double приводит к значению 0.95, но это может быть ошибкой
            // пример: "Шок. Спартак гор.элит.  99 пр.95гр" - вместо "95 граммов" распарсится "0.95 граммов"
            // чтобы этого избежать - убираем все точки в начале
            for _ in 0..<currentNumberForOutputString.count {
                if (currentNumberForOutputString.count > 0 && String(currentNumberForOutputString[currentNumberForOutputString.index(currentNumberForOutputString.startIndex, offsetBy: 0)]) == ".") {
                    currentNumberForOutputString.remove(at: currentNumberForOutputString.index(currentNumberForOutputString.startIndex, offsetBy: 0))
                }
            }
            // если получилось найти значение количества товара
            if let currentNumberDouble = Double(currentNumberForOutputString) {
                // то из enum подбираем соответствующий элемент и возвращаем кортеж (единица, количество)
                switch element.key {
                case "Г", "ГР", "G", "GR": return (.g, currentNumberDouble)
                case "КГ", "KG": return (.kg, currentNumberDouble)
                case "МЛ", "ML": return (.ml, currentNumberDouble)
                case "Л", "L": return (.l, currentNumberDouble)
                case "ШТ": return (.pcs, currentNumberDouble)
                default: break outerCycle
                }
            } else { // иначе продолжаем поиск
                continue
            }
        }
        return nil
    }
}

