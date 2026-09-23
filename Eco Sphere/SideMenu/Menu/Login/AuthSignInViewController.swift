import UIKit

class AuthSignInViewController: UIViewController {
    
    // MARK: - UI Elements
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Вход в аккаунт"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .appText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Эл. почта"
        tf.backgroundColor = .systemGroupedBackground
        tf.font = .systemFont(ofSize: 15)
        tf.layer.cornerRadius = 12
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.setLeftPadding(16)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Пароль"
        tf.backgroundColor = .systemGroupedBackground
        tf.font = .systemFont(ofSize: 15)
        tf.layer.cornerRadius = 12
        tf.isSecureTextEntry = true // Скрываем вводимый пароль точками
        tf.autocapitalizationType = .none
        tf.setLeftPadding(16)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let loginButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.background.cornerRadius = 14
        
        var titleAttr = AttributedString("Вход")
        titleAttr.font = .systemFont(ofSize: 15, weight: .semibold)
        config.attributedTitle = titleAttr
        config.baseBackgroundColor = .label
        config.baseForegroundColor = .systemBackground
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayout() // Вызовется из файла +Layout.swift
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIColor.applyGlobalTheme(for: self)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupNavigationBar() {
        title = "Авторизация"
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .appText
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        emailTextField.addDoneButtonOnKeyboard()
        passwordTextField.addDoneButtonOnKeyboard()
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func loginTapped() {
        dismissKeyboard()
        
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        if email.isEmpty || password.isEmpty {
            let alert = UIAlertController(title: "Ошибка", message: "Пожалуйста, заполните все поля ввода.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default))
            present(alert, animated: true)
            return
        }
        
        // Симуляция успешного входа: выставляем системные флаги авторизации
        // Симуляция успешного входа: выставляем системные флаги авторизации
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "menu_user_logged_in")
        defaults.set(email, forKey: "user_profile_email")
        
        // БЕЗОПАСНОЕ СОХРАНЕНИЕ: Если имя в памяти уже есть (например, Алишер Каримов),
        // мы его НЕ затираем. Заглушку ставим только если там абсолютно пусто!
        if defaults.string(forKey: "user_profile_name") == nil {
            defaults.set("Новый Пользователь", forKey: "user_profile_name")
        }
        
        if defaults.string(forKey: "user_profile_phone") == nil {
            defaults.set("+998 90 000 00 00", forKey: "user_profile_phone")
        }
        
        if defaults.string(forKey: "user_profile_city") == nil {
            defaults.set("Ташкент", forKey: "user_profile_city")
        }
        
        // Генерируем запись в Центр уведомлений со звуком
        NotificationManager.shared.addNotification(
            title: "Успешный вход в аккаунт",
            body: "Произведен успешный вход в систему Eco Sphere под учетной записью \(email).",
            type: .security
        )
        
        let alert = UIAlertController(title: "Успешно", message: "Вы успешно вошли в свой аккаунт!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "✅ Отлично", style: .default, handler: { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        }))
        present(alert, animated: true)

    }
}
