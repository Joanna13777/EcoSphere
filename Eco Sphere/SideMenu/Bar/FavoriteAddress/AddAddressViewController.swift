import UIKit

// Обновленный протокол: теперь умеет не только добавлять, но и обновлять
protocol AddAddressDelegate: AnyObject {
    func didAddAddress(_ address: FavoriteAddress)
    func didUpdateAddress(_ address: FavoriteAddress, at index: Int)
}

class AddAddressViewController: UIViewController {
    
    weak var delegate: AddAddressDelegate?
    
    // Свойства для режима редактирования
    private var editingIndex: Int?
    private var addressToEdit: FavoriteAddress?
    
    // MARK: - UI Elements
    private let titleTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Название (например: Дом, Работа)"
        tf.backgroundColor = .systemGroupedBackground
        tf.font = .systemFont(ofSize: 15)
        tf.layer.cornerRadius = 12
        tf.setLeftPadding(16)
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
        
        titleTextField.addDoneButtonOnKeyboard()
        addressTextField.addDoneButtonOnKeyboard()
        
        // Если передан адрес для редактирования, заполняем поля
        if let address = addressToEdit {
            titleTextField.text = address.title
            addressTextField.text = address.address
            title = "Редактировать"
            
            var config = saveButton.configuration
            config?.attributedTitle = AttributedString("Сохранить изменения")
            saveButton.configuration = config
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIColor.applyGlobalTheme(for: self)
    }
    
    // MARK: - Public Setup Method (Входная точка для редактирования)
    func configureForEditing(address: FavoriteAddress, at index: Int) {
        self.addressToEdit = address
        self.editingIndex = index
    }
    
    // MARK: - Setup UI
    private func setupNavigationBar() {
        if addressToEdit == nil { title = "Новый адрес" }
        
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
              let fullAddress = addressTextField.text, !fullAddress.isEmpty else { return }
        
        let lowercasedName = name.lowercased()
        var icon = "mappin.circle.fill"
        if lowercasedName.contains("дом") { icon = "house.fill" }
        else if lowercasedName.contains("раб") || lowercasedName.contains("офис") { icon = "briefcase.fill" }
        else if lowercasedName.contains("дач") { icon = "leaf.fill" }
        
        let resultAddress = FavoriteAddress(title: name, address: fullAddress, iconName: icon)
        
        // Разделяем логику: обновление старого или добавление нового
        if let index = editingIndex {
            delegate?.didUpdateAddress(resultAddress, at: index)
        } else {
            delegate?.didAddAddress(resultAddress)
        }
        
        navigationController?.popViewController(animated: true)
    }
}
