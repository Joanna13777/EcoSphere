import UIKit

class RegisterViewController: UIViewController {

    // MARK: - UI Элементы
    let registrationImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "user-verification")
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Имя и Фамилия"
        tf.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.0)
        tf.font = .systemFont(ofSize: 16)
        tf.layer.cornerRadius = 16
        tf.autocorrectionType = .no
        tf.setLeftPadding(16)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let phoneTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Телефон"
        tf.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.0)
        tf.font = .systemFont(ofSize: 16)
        tf.layer.cornerRadius = 16
        tf.keyboardType = .phonePad
        tf.setLeftPadding(16)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.0)
        tf.font = .systemFont(ofSize: 16)
        tf.layer.cornerRadius = 16
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.setLeftPadding(16)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Пароль"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.0)
        tf.font = .systemFont(ofSize: 16)
        tf.layer.cornerRadius = 16
        tf.setLeftPadding(16)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let eyeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.tintColor = .systemGray
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 24)
        return button
    }()
    
    let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать аккаунт", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupLayout()            // Реализован в файле +Layout
        setupActions()           // Реализован в файле +Actions
        setupTextFieldComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameTextField.becomeFirstResponder()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = ""
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = UIColor.black
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside) // Реализован в файле +Logic
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        let titleLabelButton = UILabel()
        titleLabelButton.text = "Регистрация"
        titleLabelButton.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabelButton.textColor = .black
        
        let customNavBarStack = UIStackView(arrangedSubviews: [backButton, titleLabelButton])
        customNavBarStack.axis = .horizontal
        customNavBarStack.spacing = 12
        customNavBarStack.alignment = .center
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: customNavBarStack)
    }
    
    private func setupTextFieldComponents() {
        nameTextField.delegate = self
        phoneTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        // Присваиваем жесткие номера каждому полю, чтобы исключить путаницу в логике
        nameTextField.tag = 1
        phoneTextField.tag = 2
        emailTextField.tag = 3
        passwordTextField.tag = 4
        
        let paddingContainer = UIView(frame: CGRect(x: 0, y: 0, width: 56, height: 24))
        eyeButton.frame = CGRect(x: 8, y: 0, width: 40, height: 24)
        paddingContainer.addSubview(eyeButton)
        
        passwordTextField.rightView = paddingContainer
        passwordTextField.rightViewMode = .always
    }
}

// MARK: - Хелпер для UITextField
extension UITextField {
    func setLeftPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: 1))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
// MARK: - Canvas Preview (для Xcode 15 и новее)
#Preview {
    let registerVC = RegisterViewController()
    return UINavigationController(rootViewController: registerVC)
}
