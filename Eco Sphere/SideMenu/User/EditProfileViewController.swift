import UIKit

class EditProfileViewController: UIViewController {
    
    // MARK: - UI Элементы (Аватар)
    let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person.crop.circle.fill") // По умолчанию пустой серый круг
        iv.tintColor = UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1.0)
        let imageConfig = UIImage.SymbolConfiguration(weight: .ultraLight)
        iv.preferredSymbolConfiguration = imageConfig
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 55
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let editPhotoLabel: UILabel = {
        let label = UILabel()
        label.text = "Фото аккаунта"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.systemGray3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let editIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "pencil")
        iv.tintColor = UIColor.systemGray3
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // MARK: - Поля ввода (Текстовые поля с разделителями)
    let nameTextField = createProfileTextField(placeholder: "Имя")
    let surnameTextField = createProfileTextField(placeholder: "Фамилия")
    let cityTextField = createProfileTextField(placeholder: "Город")
    let addressTextField = createProfileTextField(placeholder: "Адрес")
    let phoneTextField = createProfileTextField(placeholder: "Телефон")
    let emailTextField = createProfileTextField(placeholder: "Эл. почта")
    
    // MARK: - Нижняя кнопка действия
    let saveButton: UIButton = {
        var config = UIButton.Configuration.filled()
        
        var titleAttr = AttributedString("Сохранить")
        titleAttr.font = .systemFont(ofSize: 15, weight: .semibold)
        config.attributedTitle = titleAttr
        
        // В обычном состоянии (до заполнения) — темно-серый цвет как на макете
        config.baseBackgroundColor = UIColor(red: 0.35, green: 0.35, blue: 0.35, alpha: 1.0)
        config.baseForegroundColor = .white
        config.background.cornerRadius = 10
        
        let button = UIButton(configuration: config, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Кастомный всплывающий Toast "Сохранено"
    let toastView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.alpha = 0.0 // Скрыт по умолчанию
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Иконка зеленой галочки
        let checkIcon = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        checkIcon.tintColor = UIColor(red: 0.22, green: 0.69, blue: 0.39, alpha: 1.0)
        checkIcon.translatesAutoresizingMaskIntoConstraints = false
        
        // Текст сообщения
        let messageLabel = UILabel()
        messageLabel.text = "Сохранено"
        messageLabel.font = .systemFont(ofSize: 15, weight: .medium)
        messageLabel.textColor = .black
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(checkIcon)
        view.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            checkIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            checkIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            checkIcon.widthAnchor.constraint(equalToConstant: 24),
            checkIcon.heightAnchor.constraint(equalToConstant: 24),
            
            messageLabel.leadingAnchor.constraint(equalTo: checkIcon.trailingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }()
    
    // MARK: - Вспомогательный статический метод для чистой генерации полей
    private static func createProfileTextField(placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.font = .systemFont(ofSize: 14)
        tf.textColor = .black
        
        // Добавляем кастомную линию разделителя вниз каждого поля
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor(red: 0.90, green: 0.90, blue: 0.92, alpha: 1.0)
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        tf.addSubview(bottomLine)
        
        NSLayoutConstraint.activate([
            bottomLine.leadingAnchor.constraint(equalTo: tf.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: tf.trailingAnchor),
            bottomLine.bottomAnchor.constraint(equalTo: tf.bottomAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }
}
