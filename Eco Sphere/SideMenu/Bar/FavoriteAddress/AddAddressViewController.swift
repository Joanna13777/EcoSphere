//  новый аккуратный экран формы ввода

import UIKit

// Протокол для передачи созданного адреса обратно на экран списка
protocol AddAddressDelegate: AnyObject {
    func didAddAddress(_ address: FavoriteAddress)
}

class AddAddressViewController: UIViewController {
    
    weak var delegate: AddAddressDelegate?
    
    // MARK: - UI Elements
    private let titleTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Название (например: Дом, Работа)"
        tf.backgroundColor = .systemGroupedBackground
        tf.font = .systemFont(ofSize: 15)
        tf.layer.cornerRadius = 12
        tf.setLeftPadding(16) // Расширение, которое мы использовали ранее
        tf.clearButtonMode = .whileEditing
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let addressTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Полный адрес"
        tf.backgroundColor = .systemGroupedBackground
        tf.font = .systemFont(ofSize: 15)
        tf.layer.cornerRadius = 12
        tf.setLeftPadding(16)
        tf.clearButtonMode = .whileEditing
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let saveButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .label
        config.background.cornerRadius = 14
        
        var titleAttr = AttributedString("Сохранить адрес")
        titleAttr.font = .systemFont(ofSize: 15, weight: .semibold)
        config.attributedTitle = titleAttr
        config.baseForegroundColor = .systemBackground
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupHierarchy()
        setupLayout()
        setupActions()
        
        // Применяем кнопку "Готово" над клавиатурой к полям
        titleTextField.addDoneButtonOnKeyboard()
        addressTextField.addDoneButtonOnKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIColor.applyGlobalTheme(for: self)
    }
    
    // MARK: - Setup
    private func setupNavigationBar() {
        title = "Новый адрес"
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .appText
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func setupHierarchy() {
        view.addSubview(titleTextField)
        view.addSubview(addressTextField)
        view.addSubview(saveButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: 50),
            
            addressTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            addressTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addressTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addressTextField.heightAnchor.constraint(equalToConstant: 50),
            
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func setupActions() {
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveTapped() {
        guard let name = titleTextField.text, !name.isEmpty,
              let fullAddress = addressTextField.text, !fullAddress.isEmpty else {
            // Простая валидация: если поля пустые, ничего не делаем
            return
        }
        
        // В зависимости от названия подставляем системную иконку
        let lowercasedName = name.lowercased()
        var icon = "mappin.circle.fill"
        if lowercasedName.contains("дом") { icon = "house.fill" }
        else if lowercasedName.contains("раб") || lowercasedName.contains("офис") { icon = "briefcase.fill" }
        else if lowercasedName.contains("дач") { icon = "leaf.fill" }
        
        let newAddress = FavoriteAddress(title: name, address: fullAddress, iconName: icon)
        
        // Передаем объект через делегат и закрываем экран
        delegate?.didAddAddress(newAddress)
        navigationController?.popViewController(animated: true)
    }
}
