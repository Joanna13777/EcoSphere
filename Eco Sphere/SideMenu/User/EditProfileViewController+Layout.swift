import UIKit

// MARK: - Жизненный цикл, Верстка и Интерактивная Логика
extension EditProfileViewController: UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIColor.applyGlobalTheme(for: self)
        
        view.backgroundColor = .appBackground
        setupLayout()
        setupActions()
        loadUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Эта строчка принудительно перекрасит профиль в темно-серый цвет
        view.backgroundColor = .appBackground

        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func setupLayout() {
        // Добавляем элементы на экран
        view.addSubview(avatarImageView)
        view.addSubview(editPhotoLabel)
        view.addSubview(editIconImageView)
        
        view.addSubview(nameTextField)
        view.addSubview(surnameTextField)
        view.addSubview(cityTextField)
        view.addSubview(addressTextField)
        view.addSubview(phoneTextField)
        view.addSubview(emailTextField)
        
        view.addSubview(saveButton)
        view.addSubview(toastView) // Тост кладется поверх всех элементов
        
        // Сборка стека полей ввода по макету
        NSLayoutConstraint.activate([
            // Аватар
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 110),
            avatarImageView.heightAnchor.constraint(equalToConstant: 110),
            
            // Текст и карандаш под аватаром
            editPhotoLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            editPhotoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -8),
            
            editIconImageView.centerYAnchor.constraint(equalTo: editPhotoLabel.centerYAnchor),
            editIconImageView.leadingAnchor.constraint(equalTo: editPhotoLabel.trailingAnchor, constant: 6),
            editIconImageView.widthAnchor.constraint(equalToConstant: 14),
            editIconImageView.heightAnchor.constraint(equalToConstant: 14),
            
            // Констрейнты полей ввода (расстояния и высота как на референсе)
            nameTextField.topAnchor.constraint(equalTo: editPhotoLabel.bottomAnchor, constant: 36),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            surnameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 12),
            surnameTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            surnameTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            surnameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            cityTextField.topAnchor.constraint(equalTo: surnameTextField.bottomAnchor, constant: 12),
            cityTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            cityTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            cityTextField.heightAnchor.constraint(equalToConstant: 44),
            
            addressTextField.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 12),
            addressTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            addressTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            addressTextField.heightAnchor.constraint(equalToConstant: 44),
            
            phoneTextField.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 12),
            phoneTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            phoneTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            phoneTextField.heightAnchor.constraint(equalToConstant: 44),
            
            emailTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 12),
            emailTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // Кнопка Сохранить привязана к низу экрана
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 48),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -48),
            saveButton.heightAnchor.constraint(equalToConstant: 48),
            
            // Центральный всплывающий Toast
            toastView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            toastView.widthAnchor.constraint(equalToConstant: 240),
            toastView.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func setupActions() {
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        // Подписываем все поля на отслеживание изменения текста
        let fields = [nameTextField, surnameTextField, cityTextField, addressTextField, phoneTextField, emailTextField]
        fields.forEach { textField in
            textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
    }
    
    // MARK: - Валидация полей и смена цвета на ЖЕЛТЫЙ
    @objc private func textFieldDidChange() {
        // Проверяем, заполнено ли хотя бы одно из ключевых полей (Имя / Фамилия)
        let isNameFilled = !(nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
            let isSurnameFilled = !(surnameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        
        if var currentConfig = saveButton.configuration {
                if isNameFilled || isSurnameFilled {
                    // Если поля заполняются — перекрашиваем кнопку в ЖЕЛТЫЙ цвет
                                currentConfig.baseBackgroundColor = UIColor(red: 0.98, green: 0.82, blue: 0.24, alpha: 1.0)
                                currentConfig.baseForegroundColor = .black
                            } else {
                                // Если поля пустые — возвращаем серый цвет
                                currentConfig.baseBackgroundColor = UIColor(red: 0.35, green: 0.35, blue: 0.35, alpha: 1.0)
                                currentConfig.baseForegroundColor = .white
                            }
                            saveButton.configuration = currentConfig
        }
    }
    
    // MARK: - Нажатие кнопки Сохранить (Показ Тоста)
//
    // блок считывания данных из UserDefaults
    func loadUserData() {
        // Используем единый ключ "menu_user_name", который уже работает на экране Меню
        let savedName = UserDefaults.standard.string(forKey: "menu_user_name") ?? ""
        
        // Если имя составное (например, "Иван Cok"), разделим его для полей Имя и Фамилия
        let nameComponents = savedName.components(separatedBy: " ")
        if nameComponents.count >= 2 {
            nameTextField.text = nameComponents[0]
            surnameTextField.text = nameComponents[1]
        } else {
            nameTextField.text = savedName
            surnameTextField.text = UserDefaults.standard.string(forKey: "user_surname") ?? ""
        }
        
        // Загружаем остальные поля
        cityTextField.text = UserDefaults.standard.string(forKey: "user_city") ?? "Ташкент"
        addressTextField.text = UserDefaults.standard.string(forKey: "user_address") ?? ""
        phoneTextField.text = UserDefaults.standard.string(forKey: "user_phone") ?? ""
        if let email = UserDefaults.standard.string(forKey: "user_email") {
            emailTextField.text = email
        } else if let authEmail = UserDefaults.standard.string(forKey: "auth_email") {
            emailTextField.text = authEmail
        } else if let loginEmail = UserDefaults.standard.string(forKey: "login_email") {
            emailTextField.text = loginEmail
        } else {
            emailTextField.text = UserDefaults.standard.string(forKey: "menu_user_email") ?? ""
        }
        
        // Принудительно вызываем проверку, чтобы кнопка СРАЗУ загорелась желтым
        textFieldDidChange()
    }

    @objc private func saveTapped() {
        view.endEditing(true)
        
        let name = nameTextField.text ?? ""
        let surname = surnameTextField.text ?? ""
        
        // Склеиваем имя и фамилию для корректного отображения в шапке Меню
        let fullName = "\(name) \(surname)".trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Сохраняем обратно в память устройства
        UserDefaults.standard.set(fullName, forKey: "menu_user_name")
        UserDefaults.standard.set(surname, forKey: "user_surname")
        UserDefaults.standard.set(cityTextField.text, forKey: "user_city")
        UserDefaults.standard.set(addressTextField.text, forKey: "user_address")
        UserDefaults.standard.set(phoneTextField.text, forKey: "user_phone")
        UserDefaults.standard.set(emailTextField.text, forKey: "user_email")
        
        // Код вызова Toast-уведомления "Сохранено"
        let dimmingView = UIView(frame: view.bounds)
        dimmingView.backgroundColor = .appBackground
        dimmingView.alpha = 0.0
        view.insertSubview(dimmingView, belowSubview: toastView)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.toastView.alpha = 1.0
            dimmingView.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.25, delay: 1.5, options: .curveEaseOut, animations: {
                self.toastView.alpha = 0.0
                dimmingView.alpha = 0.0
            }) { _ in
                dimmingView.removeFromSuperview()
            }
        }
    }

}

// MARK: - Canvas Preview
#Preview {
    let editVC = EditProfileViewController()
    return UINavigationController(rootViewController: editVC)
}
