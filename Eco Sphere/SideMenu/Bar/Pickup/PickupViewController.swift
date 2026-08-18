import UIKit

class PickupViewController: UIViewController {

    // Проверяем, залогинен ли пользователь через меню
    let isLoggedIn = UserDefaults.standard.bool(forKey: "menu_user_logged_in")

    // MARK: - UI Элементы (Поля ввода)
    let wasteTypeTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Вид отхода"
        tf.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.0)
        tf.font = .systemFont(ofSize: 15)
        tf.layer.cornerRadius = 12
        tf.setLeftPadding(16)
        tf.setRightImage(systemName: "chevron.down", tintColor: UIColor.systemGray2)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let pickupPointTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Адрес приёмочного пункта"
        tf.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.0)
        tf.font = .systemFont(ofSize: 15)
        tf.layer.cornerRadius = 12
        tf.setLeftPadding(16)
        tf.setRightImage(systemName: "chevron.down", tintColor: UIColor.systemGray2)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Имя, фамилия"
        tf.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.0)
        tf.font = .systemFont(ofSize: 15)
        tf.layer.cornerRadius = 12
        tf.setLeftPadding(16)
        tf.clearButtonMode = .whileEditing
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let phoneTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Телефон"
        tf.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.0)
        tf.font = .systemFont(ofSize: 15)
        tf.layer.cornerRadius = 12
        tf.keyboardType = .phonePad
        tf.setLeftPadding(16)
        tf.clearButtonMode = .whileEditing
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let addressTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Адрес"
        tf.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.0)
        tf.font = .systemFont(ofSize: 15)
        tf.layer.cornerRadius = 12
        tf.setLeftPadding(16)
        tf.clearButtonMode = .whileEditing
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let weightTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Примерный вес (кг)"
        tf.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.0)
        tf.font = .systemFont(ofSize: 15)
        tf.layer.cornerRadius = 12
        tf.keyboardType = .numberPad
        tf.setLeftPadding(16)
        tf.clearButtonMode = .whileEditing
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    // MARK: - НОВЫЕ ВСТРОЕННЫЕ КАЛЕНДАРИ (Как на вашем скриншоте)
    // Компактный встроенный выбор Даты
    let inlineDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        if #available(iOS 14.0, *) {
            picker.preferredDatePickerStyle = .compact // Отображает красивую кнопку-плашку на месте
        }
        picker.locale = Locale(identifier: "ru_RU")
        picker.tintColor = .black // Стиль Eco-Minimalism (черный акцент кружка)
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    // Встроенный выбор Времени (От и До интервал)
    let startTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .compact
        }
        picker.locale = Locale(identifier: "ru_RU")
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let endTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .compact
        }
        picker.locale = Locale(identifier: "ru_RU")
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    // Контейнеры-подложки, чтобы визуально сохранить ваши серые рамки вокруг дат
    let dateBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1.0).cgColor
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let timeBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1.0).cgColor
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Вспомогательные текстовые метки-подсказки внутри рамок
    let dateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Желаемая дата:"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Время (От / До):"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Поле описания
    let descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.text = "Добавить описание"
        tv.textColor = .lightGray
        tv.font = .systemFont(ofSize: 15)
        tv.backgroundColor = .white
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1.0).cgColor
        tv.layer.cornerRadius = 12
        tv.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // MARK: - Разделенная нижняя кнопка
    let bottomContainerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 1
        stack.backgroundColor = UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0)
        stack.layer.cornerRadius = 14
        stack.clipsToBounds = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: -  КНОПКА ЗАКАЗА
    let orderButton: UIButton = {
        // 1. Создаем базовую конфигурацию кнопки
        var config = UIButton.Configuration.filled()
        
        // Настраиваем темный фон и скругление
        config.baseBackgroundColor = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1.0)
        config.background.cornerRadius = 14
        
        // 2. Настраиваем текст по умолчанию через AttributedString
        var titleAttr = AttributedString("Заказать вывоз")
        titleAttr.font = .systemFont(ofSize: 15, weight: .semibold)
        config.attributedTitle = titleAttr
        
        // 3. Настраиваем иконку CAR из SF Symbols
        // Задаем конфигурацию размера, чтобы она не сжималась на симуляторе
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        config.image = UIImage(systemName: "truck.box")?.withConfiguration(imageConfig)
        
        // 4. Позиционирование иконки
        config.imagePlacement = .trailing // Переносит машину в правую часть от текста
        config.imagePadding = 12          // Создает фиксированный отступ 12pt между текстом и машиной
        
        // 5. Цвет контента
        config.baseForegroundColor = .white // Жестко красит и текст, и иконку car в БЕЛЫЙ цвет
        
        // Создаем саму кнопку
        let button = UIButton(configuration: config, primaryAction: nil)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
//            Изначально выключаем кнопку
                button.isEnabled = false
                // Настраиваем поведение: когда кнопка выключена, она становится полупрозрачной
                button.configurationUpdateHandler = { btn in
                    btn.alpha = btn.isEnabled ? 1.0 : 0.4
                }
        return button
    }()
    
    // Убрали private, теперь метод виден в файлах +Logic и +Layout
    func validateFields() {
        let isWasteTypeFilled = !(wasteTypeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        let isPickupPointFilled = !(pickupPointTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        let isWeightFilled = !(weightTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        
        let isFormValid: Bool
        
        if isLoggedIn {
            isFormValid = isWasteTypeFilled && isPickupPointFilled && isWeightFilled
        } else {
            let isNameFilled = !(nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
            let isPhoneFilled = !(phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
            let isAddressFilled = !(addressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
            
            isFormValid = isWasteTypeFilled && isPickupPointFilled && isWeightFilled &&
                          isNameFilled && isPhoneFilled && isAddressFilled
        }
        
        orderButton.isEnabled = isFormValid
    }

   
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupLayout() // Из файла +Layout
        setupActions() // Из файла +Logic
        setupDelegates() // Из файла +Logic
        
        // Собираем все текстовые поля в один массив
            let allTextFields = [
                wasteTypeTextField,
                pickupPointTextField,
                weightTextField,
                nameTextField,
                phoneTextField,
                addressTextField
            ]
            
            // Каждому полю вешаем слушатель на изменение текста
            allTextFields.forEach { textField in
                textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            }
            
            // Вызываем проверку один раз при старте, чтобы кнопка сразу заблокировалась
            validateFields()
        
                // Скрывает текст кнопки назад, оставляя чистую стрелочку (работает в iOS 14+)
                   navigationItem.backButtonDisplayMode = .minimal
        
        // Назначаем пустой UIView вместо клавиатуры, чтобы она не вылетала при нажатии на дропдауны
        wasteTypeTextField.inputView = UIView()
        pickupPointTextField.inputView = UIView()
    }
    
//     Селектор, который вызывается при вводе любого символа
       @objc private func textFieldDidChange() {
           validateFields()
       }
    
    private func setupNavigationBar() {
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
