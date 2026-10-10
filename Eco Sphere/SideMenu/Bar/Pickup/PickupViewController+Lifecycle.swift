// логикa запуска экрана и превью

import UIKit

// MARK: - Жизненный цикл экрана и Навигация
extension PickupViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Сразу задаем адаптивный цвет фона экрана и настраиваем скролл
        view.backgroundColor = .appBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        setupNavigationBar()
        
        // 2. Добавляем все элементы на экран и строим констрейнты
        setupLayout()
        
        // 3. Готовим начальное состояние напоминалки (очищаем/скрываем)
        updateSortingReminder()
        
        // 4. В последнюю очередь вешаем клики, жесты и делегаты
        setupActions()
        setupDelegates()
        setupKeyboardObservers() // При открытии клавиатуры экран автоматически поднимается
        setupPickupAddressChevronMenu() // Переопределяем правый шеврон поля адреса на кнопку
        
        pickupAddressTextField.delegate = self
        
        // 🌟 ОПТИМИЗАЦИЯ: Объединили все текстовые и инпутные поля в один единый массив
        let allInputFields: [UIResponder] = [
            wasteTypeTextField,
            pickupPointTextField,
            pickupAddressTextField,
            nameTextField,
            phoneTextField,
            addressTextField,
            weightTextField,
            descriptionTextView
        ]
        
        // Применяем расширение кнопки "Готово" и вешаем отслеживание изменений без дублирования
        allInputFields.forEach { responder in
            responder.addDoneButtonOnKeyboard()
            
            if let textField = responder as? UITextField {
                // Сначала стираем старые экшены на изменение, чтобы они не двоились в памяти
                textField.removeTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
                // Вешаем один чистый таргет
                textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            }
        }
        
        validateFields()
        navigationItem.backButtonDisplayMode = .minimal
        
        wasteTypeTextField.inputView = UIView()
        pickupPointTextField.inputView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Красим фон, поля, навигационный бар под выбранную тему
        UIColor.applyGlobalTheme(for: self)
        
        view.backgroundColor = .appBackground
        dateBorderView.layer.borderColor = UIColor.appSeparator.cgColor
        timeBorderView.layer.borderColor = UIColor.appSeparator.cgColor
        dateBorderView.backgroundColor = .appCardBackground
        timeBorderView.backgroundColor = .appCardBackground
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardFromLifecycle))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboardFromLifecycle() {
        view.endEditing(true)
    }
    
    @objc private func textFieldDidChange() {
        validateFields()
    }
    
    @objc private func pickupAddressChanged() {
        validateFields()
    }
    
    func setupNavigationBar() {
        title = "Вывоз вторсырья"
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = UIColor.appText
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        backButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
}

// MARK: - Canvas Preview
#Preview("Не зарегистрирован") {
    UserDefaults.standard.set(false, forKey: "menu_user_logged_in")
    let pickupVC = PickupViewController()
    return UINavigationController(rootViewController: pickupVC)
}

#Preview("Зарегистрирован") {
    UserDefaults.standard.set(true, forKey: "menu_user_logged_in")
    let pickupVC = PickupViewController()
    return UINavigationController(rootViewController: pickupVC)
}
