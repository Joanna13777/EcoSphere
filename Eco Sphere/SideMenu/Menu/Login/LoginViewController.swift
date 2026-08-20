import UIKit

class LoginViewController: UIViewController {

    // MARK: - UI Элементы
    let loginImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "user-verification")
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
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
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let registerRedirectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Регистрация", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupLayout()
        setupActions()           // Реализован во втором файле
        setupTextFieldComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.becomeFirstResponder()
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupNavigationBar() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside) // Экшен во втором файле
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        let titleLabelButton = UILabel()
        titleLabelButton.text = "Вход в аккаунт"
        titleLabelButton.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabelButton.textColor = .black
        
        let customNavBarStack = UIStackView(arrangedSubviews: [backButton, titleLabelButton])
        customNavBarStack.axis = .horizontal
        customNavBarStack.spacing = 12
        customNavBarStack.alignment = .center
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: customNavBarStack)
    }
    
    private func setupTextFieldComponents() {
        emailTextField.delegate = self    // Делегат во втором файле
        passwordTextField.delegate = self
        
        emailTextField.tag = 10
        passwordTextField.tag = 20
        
        let paddingContainer = UIView(frame: CGRect(x: 0, y: 0, width: 56, height: 24))
        eyeButton.frame = CGRect(x: 8, y: 0, width: 40, height: 24)
        paddingContainer.addSubview(eyeButton)
        
        passwordTextField.rightView = paddingContainer
        passwordTextField.rightViewMode = .always
    }
    
    private func setupLayout() {
        view.addSubview(loginImageView)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(registerRedirectButton)
        
        NSLayoutConstraint.activate([
            loginImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            loginImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginImageView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.85),
            loginImageView.heightAnchor.constraint(equalToConstant: 220),
            
            emailTextField.topAnchor.constraint(equalTo: loginImageView.bottomAnchor, constant: 24),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            emailTextField.heightAnchor.constraint(equalToConstant: 54),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            passwordTextField.heightAnchor.constraint(equalToConstant: 54),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 28),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            loginButton.heightAnchor.constraint(equalToConstant: 54),
            
            registerRedirectButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            registerRedirectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
