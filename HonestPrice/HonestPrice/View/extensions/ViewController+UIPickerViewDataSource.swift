import UIKit

extension ViewController: UIPickerViewDataSource {
    // сколько компонентов выводится
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // сколько строк выводится
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
}
