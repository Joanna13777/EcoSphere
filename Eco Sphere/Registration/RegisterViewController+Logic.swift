import UIKit

// MARK: - Бизнес-логика ввода и валидация формы
extension RegisterViewController: UITextFieldDelegate {
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        // Если тег равен 2 (это поле телефона), ставим плюс
        if textField.tag == 2 {
            if textField.text?.isEmpty ?? true {
                textField.text = "+"
            }
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 2 && textField.text == "+" {
            textField.text = ""
        }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Всегда разрешаем стирание символов (Backspace)
        if string.isEmpty {
            // Защита от удаления стартового знака "+" в телефоне (тег 2)
            if textField.tag == 2 && range.location == 0 && range.length == 1 {
                return false
            }
            return true
        }
        
        // Фильтрация ввода на основе цифровых тегов полей:
        switch textField.tag {
        case 1:
            // ИМЯ И ФАМИЛИЯ: Русский, Английский, Узбекский (кириллица + латиница с апострофами) + пробелы
            let allowedPattern = "^[a-zA-Zа-яА-ЯёЁўЎқҚғҒҳҲoO'’‘`´\\s]+$"
            return string.range(of: allowedPattern, options: .regularExpression) != nil
            
        case 2:
            // ТЕЛЕФОН: Строго только цифры
            let allowedPattern = "^[0-9]+$"
            return string.range(of: allowedPattern, options: .regularExpression) != nil
            
        case 3:
            // EMAIL: Строго английские буквы, цифры и спецсимволы почты
            let allowedPattern = "^[a-zA-Z0-9@._\\-+]+$"
            return string.range(of: allowedPattern, options: .regularExpression) != nil
            
        case 4:
            // ПАРОЛЬ: Строго английские буквы, цифры и любые стандартные спецсимволы
            let allowedPattern = "^[a-zA-Z0-9!@#$%^&*()_+_\\-=\\[\\]{};':\",./<>?|\\\\`~]+$"
            return string.range(of: allowedPattern, options: .regularExpression) != nil
            
        default:
            return true
        }
    }
    
    @objc func submitTapped() {
        guard let name = nameTextField.text, !name.isEmpty,
              let phone = phoneTextField.text, phone.count > 1,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Пожалуйста, заполните все поля")
            return
        }
        
        if password.count < 6 {
            showAlert(message: "Пароль должен быть не менее 6 символов")
            return
        }
        
        view.endEditing(true)
        
        // --- СИМУЛЯЦИЯ ОТПРАВКИ СМС ---
        // Генерируем случайное 4-значное число от 1000 до 9999
        let mockGeneratedCode = String(Int.random(in: 1000...9999))
        
        // Сохраняем код в память устройства, чтобы проверить его на следующем экране
        UserDefaults.standard.set(mockGeneratedCode, forKey: "mock_verification_code")
        
        // Печатаем код в консоль Xcode жирным шрифтом, чтобы вы видели его при тестировании
        print("\n========================================")
        print("📱 СИМУЛЯЦИЯ СМС: Код подтверждения для \(phone) ➔ [ \(mockGeneratedCode) ]")
        print("========================================\n")
        
        // НАСТРОЙКА ПЕРЕХОДА:
        let verifyVC = VerificationViewController()
        verifyVC.destinationText = phone // По умолчанию пишем телефон для СМС
        verifyVC.isEmailType = false
        verifyVC.userName = name         // Передаем имя
        
        // Новая строка: Передаем введенный пользователем Email в память экрана верификации
        // Чтобы при переключении на Email мы знали, куда слать код
        if let enteredEmail = emailTextField.text {
            UserDefaults.standard.set(enteredEmail, forKey: "user_registered_email")
        }
        
        navigationController?.pushViewController(verifyVC, animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Внимание", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
}
