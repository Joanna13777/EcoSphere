import UIKit

// MARK: - Верстка интерфейса (Auto Layout)
extension RegisterViewController {
    
    func setupLayout() {
        view.addSubview(registrationImageView)
        view.addSubview(nameTextField)
        view.addSubview(phoneTextField)  // Добавляем на экран в новом порядке
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            // 1. Картинка на самом верху контента
            registrationImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            registrationImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registrationImageView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.85),
            registrationImageView.heightAnchor.constraint(equalToConstant: 300),
            
            // 2. [ПЕРВОЕ ПОЛЕ] Имя и Фамилия опирается на низ картинки
            nameTextField.topAnchor.constraint(equalTo: registrationImageView.bottomAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            nameTextField.heightAnchor.constraint(equalToConstant: 54),
            
            // 3. [ВТОРОЕ ПОЛЕ] Телефон теперь опирается на низ поля Имени
            phoneTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            phoneTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            phoneTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            phoneTextField.heightAnchor.constraint(equalToConstant: 54),
            
            // 4. [ТРЕТЬЕ ПОЛЕ] Email теперь опирается на низ поля Телефона
            emailTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 16),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            emailTextField.heightAnchor.constraint(equalToConstant: 54),
            
            // 5. [ЧЕТВЕРТОЕ ПОЛЕ] Пароль по-прежнему опирается на низ поля Email
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            passwordTextField.heightAnchor.constraint(equalToConstant: 54),
            
            // Кнопка создания аккаунта под паролем
            submitButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 28),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            submitButton.heightAnchor.constraint(equalToConstant: 54)
        ])
    }
}
