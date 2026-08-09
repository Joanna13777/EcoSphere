import UIKit

class VerificationViewController: UIViewController, UITextFieldDelegate {
    
    var destinationText: String = ""
    var isEmailType: Bool = false // По умолчанию работаем с СМС
    var userName: String = "" // Сюда прилетит имя с экрана регистрации

    
    // Переменные для управления таймером
    private var countdownTimer: Timer?
    private var remainingSeconds = 60
    
    // MARK: - UI Элементы
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let codeTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "••••"
        tf.font = .systemFont(ofSize: 32, weight: .bold)
        tf.textAlignment = .center
        tf.keyboardType = .numberPad
        tf.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.0)
        tf.layer.cornerRadius = 16
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let verifyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Подтвердить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Новая метка таймера под кнопкой
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupLayout()
        
        codeTextField.delegate = self
        verifyButton.addTarget(self, action: #selector(verifyTapped), for: .touchUpInside)
        
        updateDescriptionText()
        startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        codeTextField.becomeFirstResponder()
        // Включаем видимость бара навигации, чтобы кнопка Назад отображалась
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer() // Обязательно тушим таймер при уходе с экрана, чтобы избежать утечек памяти
    }
    
    // MARK: - Логика таймера
    private func startTimer() {
        stopTimer()
        remainingSeconds = 60
        updateTimerLabelText()
        
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.remainingSeconds > 0 {
                self.remainingSeconds -= 1
                self.updateTimerLabelText()
            } else {
                self.stopTimer()
                self.showResendOptionsAlert()
            }
        }
    }
    
    private func stopTimer() {
        countdownTimer?.invalidate()
        countdownTimer = nil
    }
    
    private func updateTimerLabelText() {
        timerLabel.text = "Повторный код через: \(remainingSeconds) сек"
    }
    
    private func updateDescriptionText() {
        let channel = isEmailType ? "на почту" : "по СМС на номер"

        // Отображаем персональное имя аккаунта на экране подтверждения
        descriptionLabel.text = "Уважаемый(-ая) \(userName)!\nМы отправили код подтверждения \(channel):\n\(destinationText)"
    }
    
    // MARK: - Окно выбора при 0 секунд
    private func showResendOptionsAlert() {
        let alert = UIAlertController(
            title: "Отправить код еще раз?",
            message: "Или отправить на email?",
            preferredStyle: .alert
        )
        
        // 1. Кнопка "Да" ➔ Генерируем новый СМС код
        let yesAction = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            let newMockCode = String(Int.random(in: 1000...9999))
            UserDefaults.standard.set(newMockCode, forKey: "mock_verification_code")
            
            print("\n========================================")
            print("🔄 ПОВТОРНОЕ СМС: Новый код для \(self.destinationText) ➔ [ \(newMockCode) ]")
            print("========================================\n")
            
            self.startTimer()
        }
        
        // 2. Кнопка "Нет" ➔ Просто закрываем окно
        let noAction = UIAlertAction(title: "Нет", style: .default) { [weak self] _ in
            self?.timerLabel.text = "Код истек"
        }
        
        // 3. Кнопка "Отправить на Email" ➔ Генерируем код для почты
        let emailAction = UIAlertAction(title: "Отправить на Email", style: .default) { [weak self] _ in
                    guard let self = self else { return }
                    self.isEmailType = true
            
            // Читаем из памяти реальный email, который пользователь ввел на экране регистрации
                        // Если там пусто (маловероятно), используем резервную заглушку
                        let savedEmail = UserDefaults.standard.string(forKey: "user_registered_email") ?? "no_email@domain.com"
                        
                        // Обновляем текст на экране актуальным адресом почты
                        self.destinationText = savedEmail
            
            let newMockCode = String(Int.random(in: 1000...9999))
                        UserDefaults.standard.set(newMockCode, forKey: "mock_verification_code")
                        print("📧 СИМУЛЯЦИЯ EMAIL: Новый код отправлен на почту \(self.destinationText) ➔ [ \(newMockCode) ]")
                        
                        self.updateDescriptionText()
                        self.startTimer()
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        alert.addAction(emailAction)
        
        present(alert, animated: true)
    }


    
    // MARK: - Стилизация Навигации и Верстка
    private func setupNavigationBar() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        let titleLabelButton = UILabel()
        titleLabelButton.text = "Подтверждение"
        titleLabelButton.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabelButton.textColor = .black
        
        let customNavBarStack = UIStackView(arrangedSubviews: [backButton, titleLabelButton])
        customNavBarStack.axis = .horizontal
        customNavBarStack.spacing = 12
        customNavBarStack.alignment = .center
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: customNavBarStack)
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func verifyTapped() {
        let cleanCode = (codeTextField.text ?? "").replacingOccurrences(of: " ", with: "")
        guard cleanCode.count == 4 else { return }
        
        verifyButton.isEnabled = false
        view.endEditing(true)
        
        // Достаем код, который мы сгенерировали на первом экране (или при переотправке)
        // Если кода почему-то нет в памяти, по умолчанию используем тестовый "1111"
        let savedMockCode = UserDefaults.standard.string(forKey: "mock_verification_code") ?? "1111"
        
        // Имитируем небольшую задержку сети (0.5 секунды), чтобы кнопка красиво заблокировалась
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            if cleanCode == savedMockCode {
                // КОД ВЕРНЫЙ ➔ Пускаем в приложение
                UserDefaults.standard.set(false, forKey: "is_first_launch")
                
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    let mainTabBar = MainTabBarController()
                    window.rootViewController = mainTabBar
                    UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
                }
            } else {
                // КОД НЕВЕРНЫЙ ➔ Показываем ошибку и очищаем поле ввода
                self.verifyButton.isEnabled = true
                self.codeTextField.text = ""
                
                let alert = UIAlertController(title: "Ошибка", message: "Введен неверный код подтверждения. Попробуйте еще раз.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ОК", style: .default) { _ in
                    self.codeTextField.becomeFirstResponder() // Возвращаем фокус на ввод
                })
                self.present(alert, animated: true)
            }
        }
    }
    
    private func setupLayout() {
        view.addSubview(descriptionLabel)
        view.addSubview(codeTextField)
        view.addSubview(verifyButton)
        view.addSubview(timerLabel) // Добавляем таймер на экран
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            codeTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 32),
            codeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            codeTextField.widthAnchor.constraint(equalToConstant: 240),
            codeTextField.heightAnchor.constraint(equalToConstant: 64),
            
            verifyButton.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 32),
            verifyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            verifyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            verifyButton.heightAnchor.constraint(equalToConstant: 54),
            
            // Констрейнты для метки таймера строго под кнопкой подтверждения
            timerLabel.topAnchor.constraint(equalTo: verifyButton.bottomAnchor, constant: 20),
            timerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            timerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        let cleanDigits = updatedText.replacingOccurrences(of: " ", with: "")
        guard cleanDigits.count <= 4 && cleanDigits.allSatisfy({ $0.isNumber }) else { return false }
        let formattedText = cleanDigits.map { String($0) }.joined(separator: " ")
        textField.text = formattedText
        if cleanDigits.count == 4 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.verifyTapped()
            }
        }
        return false
    }
}

