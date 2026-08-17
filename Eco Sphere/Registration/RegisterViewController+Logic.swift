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
        
        // --- ЗАПИСЬ ДАННЫХ РЕГИСТРАЦИИ В ПАМЯТЬ ---
        // Приводим email к нижнему регистру, чтобы избежать ошибок при вводе разным шрифтом
        let cleanEmail = email.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        UserDefaults.standard.set(name, forKey: "saved_user_name")
        UserDefaults.standard.set(phone, forKey: "saved_user_phone")
        UserDefaults.standard.set(cleanEmail, forKey: "saved_user_email")
        UserDefaults.standard.set(password, forKey: "saved_user_password")
        
        // Имитируем отправку проверочного кода на экран СМС (как делали ранее)
        let mockGeneratedCode = String(Int.random(in: 1000...9999))
        UserDefaults.standard.set(mockGeneratedCode, forKey: "mock_verification_code")
        
        print("\n========================================")
        print("💾 АККАУНТ ЗАРЕГИСТРИРОВАН:")
        print("👤 Имя: \(name)")
        print("📧 Email: \(cleanEmail)")
        print("🔑 Пароль: \(password)")
        print("📱 Код СМС: [ \(mockGeneratedCode) ]")
        print("========================================\n")
        
        let verifyVC = VerificationViewController()
        verifyVC.destinationText = phone
        verifyVC.isEmailType = false
        verifyVC.userName = name
        
        // Передаем email на экран верификации
        UserDefaults.standard.set(cleanEmail, forKey: "user_registered_email")
        
        navigationController?.pushViewController(verifyVC, animated: true)
    }

    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Внимание", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
}
