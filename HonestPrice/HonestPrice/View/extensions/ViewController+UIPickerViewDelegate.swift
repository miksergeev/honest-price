import UIKit

extension ViewController : UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let arrayForPackages = ["МЛ", "Г", "Л", "КГ", "ШТ"]
        let result = arrayForPackages[row]
        return result
    }
}
