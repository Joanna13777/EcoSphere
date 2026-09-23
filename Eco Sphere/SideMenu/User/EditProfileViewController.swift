// основной файл профиля. Здесь остаются только UI-компоненты, фабричный метод и методы жизненного цикла (viewDidLoad, viewWillAppear).

import UIKit
import MapKit

protocol EditProfileDelegate: AnyObject {
    func didUpdateProfileData()
}

class EditProfileViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - Properties
    weak var delegate: EditProfileDelegate?
    var citiesDropDownView: SortingDropDownView?
    var isDropDownVisible = false
    let geocoder = CLGeocoder()
    
    // MARK: - UI Elements (Containers)
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.alwaysBounceVertical = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - UI Elements (Profile Views)
    let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person.crop.circle.fill")
        iv.tintColor = .systemGray4
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let changeAvatarButton: UIButton = {
        var config = UIButton.Configuration.plain()
        var titleAttr = AttributedString("Изменить фото")
        titleAttr.font = .systemFont(ofSize: 14, weight: .medium)
        config.attributedTitle = titleAttr
        config.image = UIImage(systemName: "pencil")
        config.imagePlacement = .trailing
        config.imagePadding = 6
        config.baseForegroundColor = .systemGray
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let nameTextField = EditProfileViewController.createProfileTextField(placeholder: "Имя")
    let surnameTextField = EditProfileViewController.createProfileTextField(placeholder: "Фамилия")
    let cityTextField = EditProfileViewController.createProfileTextField(placeholder: "Город", hasChevron: true)
    let addressTextField = EditProfileViewController.createProfileTextField(placeholder: "Адрес", hasMapIcon: true)
    let phoneTextField = EditProfileViewController.createProfileTextField(placeholder: "Телефон", keyboardType: .phonePad)
    let emailTextField = EditProfileViewController.createProfileTextField(placeholder: "Эл. почта", keyboardType: .emailAddress)
    
    let saveButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .label
        config.background.cornerRadius = 14
        config.attributedTitle = AttributedString("Сохранить")
        config.baseForegroundColor = .systemBackground
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
   // кнопка-ссылка «Вход в аккаунт»
    let navigateToLoginButton: UIButton = {
        let button = UIButton(type: .system)
        
        // Создаем красивый текст ссылки с подчеркиванием
        let title = "Уже зарегистрированы? Вход в аккаунт"
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .medium),
            .foregroundColor: UIColor.systemGray, // Нейтральный цвет, как на хлебных крошках
            .underlineStyle: NSUnderlineStyle.single.rawValue // Включаем нативное подчеркивание текста
        ]
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        //  Принудительно включаем жесты для элемента
                button.isUserInteractionEnabled = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayout() // Вызов из файла +Layout.swift
        setupKeyboardInteractions()
        setupDelegatesAndActions()
        navigateToLoginButton.addTarget(self, action: #selector(navigateToLoginTapped), for: .touchUpInside)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 1. Применяем глобальную тему оформления (светлая/темная)
        UIColor.applyGlobalTheme(for: self)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        // 2. ЗАГРУЖАЕМ ДАННЫЕ ИЗ ПАМЯТИ ОБРАТНО В ТЕКСТОВЫЕ ПОЛЯ
        let defaults = UserDefaults.standard
        
        // Разделяем сохраненную строку полного имени обратно на Имя и Фамилию
        if let fullName = defaults.string(forKey: "user_profile_name"), !fullName.isEmpty {
            let components = fullName.components(separatedBy: " ")
            nameTextField.text = components.first
            if components.count > 1 {
                surnameTextField.text = components.dropFirst().joined(separator: " ")
            }
        }
        
        // Загружаем остальные поля
        cityTextField.text = defaults.string(forKey: "user_profile_city") ?? "Ташкент"
        
        // --- НАЧАЛО ИСПРАВЛЕНИЯ: АВТО-ОЧИСТКА АДРЕСА ПРИ ЗАГРУЗКЕ ЭКРАНА ---
        let rawAddress = defaults.string(forKey: "user_profile_address") ?? ""
        let pattern = "(?i)(г\\.?\\s*)?ташкент\\s*,?\\s*"
        
        // Стираем слово "Ташкент" и "г."
        var cleanLoadedAddress = rawAddress.replacingOccurrences(of: pattern, with: "", options: .regularExpression)
        cleanLoadedAddress = cleanLoadedAddress.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Убираем случайную запятую в начале, если она осталась
        if cleanLoadedAddress.hasPrefix(",") { cleanLoadedAddress.removeFirst() }
        
        // Записываем финальный чистый адрес в поле
        addressTextField.text = cleanLoadedAddress.trimmingCharacters(in: .whitespacesAndNewlines)
        // --- КОНЕЦ ИСПРАВЛЕНИЯ ---
        
        phoneTextField.text = defaults.string(forKey: "user_profile_phone") ?? "+"
        emailTextField.text = defaults.string(forKey: "user_profile_email") ?? ""
        
        // Загружаем и устанавливаем сохраненное фото аватара
        if let avatarData = defaults.data(forKey: "user_profile_avatar_data"),
           let savedImage = UIImage(data: avatarData) {
            avatarImageView.image = savedImage
        } else {
            avatarImageView.image = UIImage(systemName: "person.crop.circle.fill")
        }
    }


    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Factory Method
    private static func createProfileTextField(placeholder: String, keyboardType: UIKeyboardType = .default, hasMapIcon: Bool = false, hasChevron: Bool = false) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.backgroundColor = .systemGroupedBackground
        tf.font = .systemFont(ofSize: 15)
        tf.layer.cornerRadius = 12
        tf.keyboardType = keyboardType
        tf.clearButtonMode = (hasMapIcon || hasChevron) ? .never : .whileEditing
        tf.setLeftPadding(16)
        
        if hasMapIcon {
            let mapButton = UIButton(type: .system)
            mapButton.setImage(UIImage(systemName: "map.fill"), for: .normal)
            mapButton.tintColor = .systemGray
            mapButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            tf.rightView = mapButton
            tf.rightViewMode = .always
        }
        
        if hasChevron {
            let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.down"))
            chevronImageView.tintColor = .systemGray2
            chevronImageView.contentMode = .center
            chevronImageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            tf.rightView = chevronImageView
            tf.rightViewMode = .always
        }
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }
    // метод-обработчик перехода
    @objc private func navigateToLoginTapped() {
        let loginVC = AuthSignInViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
}
