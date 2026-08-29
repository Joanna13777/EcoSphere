// логикa запуска экрана и превью

import UIKit

// MARK: - Жизненный цикл экрана и Навигация
extension PickupViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UIColor.applyGlobalTheme(for: self)
        
        // 1. Сразу задаем адаптивный цвет фона экрана
        view.backgroundColor = .appBackground
        // добавляем скролл и его контейнер на главный view
                view.addSubview(scrollView)
                scrollView.addSubview(contentView)
        
        setupNavigationBar()
        
        // 2. СНАЧАЛА добавляем все элементы на экран и строим констрейнты
        setupLayout()
        
        // 3. СРАЗУ ПОСЛЕ ЭТОГО готовим начальное состояние напоминалки (очищаем/скрываем)
        updateSortingReminder()
        
        // 4. В последнюю очередь вешаем клики, жесты и делегаты
        setupActions()
        setupDelegates()
        setupKeyboardObservers() // при открытии клавиатуры экран автоматически поднимался
        
        // изменения текста в полях ввода
        let allTextFields = [
            wasteTypeTextField, pickupPointTextField, weightTextField,
            nameTextField, phoneTextField, addressTextField
        ]
        
        // Находим все текстовые поля и область текста на экране и добавляем им кнопку "Готово"
        let allInputFields: [UIResponder] = [
            wasteTypeTextField,
            pickupPointTextField,
            nameTextField,
            phoneTextField,
            addressTextField,
            weightTextField,
            descriptionTextView
        ]
        
        // Применяем расширение к каждому элементу
        allInputFields.forEach { $0.addDoneButtonOnKeyboard() }
        
        
        
        
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
        
        // Сканер сам пробежится по экрану, найдет кастомную кнопку возврата и перекрасит её!
        //UIColor.applyGlobalTheme(for: self)
        
        view.backgroundColor = .appBackground
        dateBorderView.layer.borderColor = UIColor.appSeparator.cgColor
        timeBorderView.layer.borderColor = UIColor.appSeparator.cgColor
        dateBorderView.backgroundColor = .appCardBackground
        timeBorderView.backgroundColor = .appCardBackground
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupDismissKeyboardGesture() {
        // Изменили dismissKeyboard на dismissKeyboardFromLifecycle
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardFromLifecycle))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboardFromLifecycle() { // Переименовали метод тут
        view.endEditing(true)
    }
    
    @objc private func textFieldDidChange() {
        validateFields()
    }
    
    func setupNavigationBar() {
        title = "Вывоз вторсырья"
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        
        // ИСПРАВЛЕНО: Используем наш глобальный адаптивный цвет текста вместо проверки isDark
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
