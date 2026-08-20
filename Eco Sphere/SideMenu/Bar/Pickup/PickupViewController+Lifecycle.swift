// логикa запуска экрана и превью

import UIKit

// MARK: - Жизненный цикл экрана и Навигация
extension PickupViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupLayout()
        setupActions()
        setupDelegates()
        
        let allTextFields = [
            wasteTypeTextField,
            pickupPointTextField,
            weightTextField,
            nameTextField,
            phoneTextField,
            addressTextField
        ]
        
        allTextFields.forEach { textField in
            textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }
        
        validateFields()
        navigationItem.backButtonDisplayMode = .minimal
        
        wasteTypeTextField.inputView = UIView()
        pickupPointTextField.inputView = UIView()
    }
    
    @objc private func textFieldDidChange() {
        validateFields()
    }
    
    func setupNavigationBar() {
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
