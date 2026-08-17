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
    
    // MARK: - Новая цельная кнопка заказа в стиле Eco-Minimalism (ИСПРАВЛЕНО)
    let orderButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1.0)
        button.layer.cornerRadius = 14
        button.clipsToBounds = true
        
        // 1. Настраиваем текст "Заказать вывоз" по центру
        button.setTitle("Заказать вывоз", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        
        // 2. Создаем и принудительно окрашиваем иконку грузовика в белый цвет шаблона
        let truckImage = UIImage(systemName: "truck.fill")?.withRenderingMode(.alwaysTemplate)
        let truckImageView = UIImageView(image: truckImage)
        truckImageView.tintColor = .white // Строго белый цвет
        truckImageView.contentMode = .scaleAspectFit
        truckImageView.translatesAutoresizingMaskIntoConstraints = false
        
        button.addSubview(truckImageView)
        
        // 3. Жестко привязываем белую машинку к правому краю внутри самой кнопки
        NSLayoutConstraint.activate([
            truckImageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -20),
            truckImageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            truckImageView.widthAnchor.constraint(equalToConstant: 24),
            truckImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        // 4. Тонкая вертикальная разделительная линия перед машинкой (как на вашем макете)
        let verticalLine = UIView()
        verticalLine.backgroundColor = UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0)
        verticalLine.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(verticalLine)
        
        NSLayoutConstraint.activate([
            verticalLine.trailingAnchor.constraint(equalTo: truckImageView.leadingAnchor, constant: -16),
            verticalLine.topAnchor.constraint(equalTo: button.topAnchor),
            verticalLine.bottomAnchor.constraint(equalTo: button.bottomAnchor),
            verticalLine.widthAnchor.constraint(equalToConstant: 1)
        ])
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()



    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupLayout() // Из файла +Layout
        setupActions() // Из файла +Logic
        setupDelegates() // Из файла +Logic
        
        // Назначаем пустой UIView вместо клавиатуры, чтобы она не вылетала при нажатии на дропдауны
        wasteTypeTextField.inputView = UIView()
        pickupPointTextField.inputView = UIView()

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
