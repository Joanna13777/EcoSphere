import UIKit

// MARK: - Глобальные расширения для UITextField
extension UITextField {
    
    func setRightImage(systemName: String, tintColor: UIColor) {
        // ПРОВЕРКА: Если в rightView уже лежит UIButton (наша кнопка шеврона для адреса),
        // мы не удаляем её, а просто меняем ей иконку через современную конфигурацию!
        if let chevronButton = self.rightView as? UIButton {
            var updatedConfig = chevronButton.configuration
            updatedConfig?.image = UIImage(systemName: systemName)
            chevronButton.configuration = updatedConfig
            return // Выходим, чтобы не затереть кнопку картинкой
        }
        
        // Для остальных полей (где кнопок нет) оставляем стандартную логику с UIImageView:
        let iv = UIImageView(image: UIImage(systemName: systemName))
        iv.tintColor = tintColor
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = false
        
        let paddingContainer = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 20))
        paddingContainer.isUserInteractionEnabled = false
        
        iv.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        paddingContainer.addSubview(iv)
        
        self.rightView = paddingContainer
        self.rightViewMode = .always
    }

}

// MARK: - Глобальные расширения для UIStackView
extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { self.addArrangedSubview($0) }
    }
}

// MARK: - расширение для создания панели «Готово»
extension UIResponder {
    func addDoneButtonOnKeyboard() {
        // Создаем панель над клавиатурой
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        // Гибкое пространство, чтобы сдвинуть кнопку вправо
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        // Системная кнопка "Готово" (сама переведется на язык устройства: Done / Готово)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonAction))
        doneButton.tintColor = .systemBlue // Цвет текста кнопки
        
        doneToolbar.items = [flexSpace, doneButton]
        doneToolbar.sizeToFit()
        
        // Проверяем тип объекта и назначаем тулбар
        if let textField = self as? UITextField {
            textField.inputAccessoryView = doneToolbar
        } else if let textView = self as? UITextView {
            textView.inputAccessoryView = doneToolbar
        }
    }
    
    @objc private func doneButtonAction() {
        self.resignFirstResponder() // Скрывает клавиатуру с экрана
    }
}
