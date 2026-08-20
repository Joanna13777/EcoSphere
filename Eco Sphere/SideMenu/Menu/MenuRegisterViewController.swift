import UIKit

// MARK: - Business Logic & Delegates для экрана Входа
extension LoginViewController: UITextFieldDelegate {
    
    func setupActions() {
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        registerRedirectButton.addTarget(self, action: #selector(registerRedirectTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        eyeButton.setImage(UIImage(systemName: imageName), for: .normal)
        if let text = passwordTextField.text {
            passwordTextField.text = nil
            passwordTextField.text = text
        }
    }
    
    // проводил реальную сверку Email и Пароля:
    @objc private func loginTapped() {
        guard let enteredEmail = emailTextField.text, !enteredEmail.isEmpty,
              let enteredPassword = passwordTextField.text, !enteredPassword.isEmpty else {
            showAlert(message: "Пожалуйста, введите Email и Пароль")
            return
        }
        
        view.endEditing(true)
        
        // Очищаем введенный email для точного сравнения
        let cleanEnteredEmail = enteredEmail.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Извлекаем из памяти данные аккаунта, который прошел регистрацию
        let savedEmail = UserDefaults.standard.string(forKey: "saved_user_email")
        let savedPassword = UserDefaults.standard.string(forKey: "saved_user_password")
        let savedName = UserDefaults.standard.string(forKey: "saved_user_name") ?? "Пользователь"
        
        // --- ЛОГИКА СВЕРКИ ДАННЫХ ---
        if savedEmail == nil {
            // Если в памяти вообще пусто, значит никто еще ни разу не регистрировался
            showAlert(message: "Пользователь с таким Email не найден. Пожалуйста, пройдите регистрацию.")
            return
        }
        
        if cleanEnteredEmail == savedEmail && enteredPassword == savedPassword {
            // ДАННЫЕ СОВПАЛИ ➔ Авторизуем пользователя в Боковом Меню
            UserDefaults.standard.set(true, forKey: "menu_user_logged_in")
            UserDefaults.standard.set(savedName, forKey: "menu_user_name")
            
            let successAlert = UIAlertController(title: "Успешно", message: "Вы успешно вошли в свой аккаунт!", preferredStyle: .alert)
            successAlert.addAction(UIAlertAction(title: "ОК", style: .default) { [weak self] _ in
                // Возвращаем пользователя обратно на экран Меню
                self?.navigationController?.popViewController(animated: true)
            })
            present(successAlert, animated: true)
            
        } else {
            // ДАННЫЕ НЕ СОВПАЛИ ➔ Выводим ошибку
            showAlert(message: "Неверный Email или Пароль. Попробуйте еще раз.")
        }
    }

    
    @objc private func registerRedirectTapped() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Внимание", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Валидация по Тегам
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty { return true }
        
        if textField.tag == 10 { // Email
            let allowedPattern = "^[a-zA-Z0-9@._\\-+]+$"
            return string.range(of: allowedPattern, options: .regularExpression) != nil
        }
        
        if textField.tag == 20 { // Пароль
            let allowedPattern = "^[a-zA-Z0-9!@#$%^&*()_+_\\-=\\[\\]{};':\",./<>?|\\\\`~]+$"
            return string.range(of: allowedPattern, options: .regularExpression) != nil
        }
        
        return true
    }
}
