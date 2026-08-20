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
        tf.keyboardType = .decimalPad
        tf.setLeftPadding(16)
        tf.clearButtonMode = .whileEditing
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    // MARK: - ВСТРОЕННЫЕ КАЛЕНДАРИ
    let inlineDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        if #available(iOS 14.0, *) { picker.preferredDatePickerStyle = .compact }
        picker.locale = Locale(identifier: "ru_RU")
        picker.tintColor = .black
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let startTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        if #available(iOS 13.4, *) { picker.preferredDatePickerStyle = .compact }
        picker.locale = Locale(identifier: "ru_RU")
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let endTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        if #available(iOS 13.4, *) { picker.preferredDatePickerStyle = .compact }
        picker.locale = Locale(identifier: "ru_RU")
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
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
    
    // MARK: - КНОПКА ЗАКАЗА
    let orderButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1.0)
        config.background.cornerRadius = 14
        
        var titleAttr = AttributedString("Заказать вывоз")
        titleAttr.font = .systemFont(ofSize: 15, weight: .semibold)
        config.attributedTitle = titleAttr
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        config.image = UIImage(systemName: "truck.box")?.withConfiguration(imageConfig)
        config.imagePlacement = .trailing
        config.imagePadding = 12
        config.baseForegroundColor = .white
        
        let button = UIButton(configuration: config, primaryAction: nil)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.configurationUpdateHandler = { btn in
            btn.alpha = btn.isEnabled ? 1.0 : 0.4
        }
        return button
    }()
    
    // MARK: - ЭЛЕМЕНТЫ ОКНА НАПОМИНАЛКИ
    let reminderTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 0.15, green: 0.25, blue: 0.18, alpha: 1.0)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var sortingReminderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.96, green: 0.98, blue: 0.96, alpha: 1.0)
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.85, green: 0.90, blue: 0.85, alpha: 1.0).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(systemName: "info.circle.fill")
        iconImageView.tintColor = UIColor(red: 0.27, green: 0.54, blue: 0.35, alpha: 1.0)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(iconImageView)
        view.addSubview(reminderTextLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            iconImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            reminderTextLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            reminderTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            reminderTextLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            reminderTextLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12)
        ])
        
        view.alpha = 0.0
        return view
    }()
}
