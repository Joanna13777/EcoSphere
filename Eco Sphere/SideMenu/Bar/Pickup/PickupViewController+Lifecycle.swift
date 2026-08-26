// логикa запуска экрана и превью

import UIKit

// MARK: - Жизненный цикл экрана и Навигация
extension PickupViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIColor.applyGlobalTheme(for: self)
        
        // 1. Сразу задаем адаптивный цвет фона экрана
        view.backgroundColor = .appBackground
        
        setupNavigationBar()
        
        // 2. СНАЧАЛА добавляем все элементы на экран и строим констрейнты
        setupLayout()
        
        // 3. СРАЗУ ПОСЛЕ ЭТОГО готовим начальное состояние напоминалки (очищаем/скрываем)
        updateSortingReminder()
        
        // 4. В последнюю очередь вешаем клики, жесты и делегаты
        setupActions()
        setupDelegates()
        
        // изменения текста в полях ввода
        let allTextFields = [
            wasteTypeTextField, pickupPointTextField, weightTextField,
            nameTextField, phoneTextField, addressTextField
        ]
        
        allTextFields.forEach { textField in
            textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        
        validateFields()
        navigationItem.backButtonDisplayMode = .minimal
        
        wasteTypeTextField.inputView = UIView()
        pickupPointTextField.inputView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 1. Перекрашиваем фон экрана вывоза в наш умный цвет
        view.backgroundColor = .appBackground
        
        // 2. Обновляем цвета внутренних рамок карточек даты и времени под тёмную тему
        dateBorderView.layer.borderColor = UIColor.appSeparator.cgColor
        timeBorderView.layer.borderColor = UIColor.appSeparator.cgColor
        dateBorderView.backgroundColor = .appCardBackground
        timeBorderView.backgroundColor = .appCardBackground
        
        // 3. Включаем отображение навигационной панели
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        // ФИКС СТРЕЛОЧКИ НАЗАД ЧЕРЕЗ APPEARANCE
        if let navBar = navigationController?.navigationBar {
            let isDark = UserDefaults.standard.integer(forKey: "selected_app_theme") == 1
            
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .appBackground // Фон панели сливается с темой экрана
            
            // Настройка цвета текста заголовка ("Вывоз вторсырья")
            appearance.titleTextAttributes = [.foregroundColor: isDark ? UIColor.white : UIColor.black]
            
            // НАСТРОЙКА КНОПОК И СТРЕЛОЧКИ НАЗАД ВНУТРИ БАРА
            let buttonAppearance = UIBarButtonItemAppearance()
            buttonAppearance.normal.titleTextAttributes = [.foregroundColor: isDark ? UIColor.white : UIColor.black]
            appearance.buttonAppearance = buttonAppearance
            appearance.backButtonAppearance = buttonAppearance
            
            // Применяем настройки к навигационному бару
            navBar.standardAppearance = appearance
            navBar.scrollEdgeAppearance = appearance
            
            // Перекрашиваем саму стрелочку на системном уровне во время отображения
            navBar.tintColor = isDark ? UIColor.white : UIColor.black
        }
    }


    
    @objc private func textFieldDidChange() {
        validateFields()
    }
    
    func setupNavigationBar() {
        title = "Вывоз вторсырья"
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
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
