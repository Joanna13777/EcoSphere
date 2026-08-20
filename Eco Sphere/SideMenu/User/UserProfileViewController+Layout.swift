// Файл логики и констрейнтов — для сборки и обработки нажатий

import UIKit

// MARK: - Верстка и Логика экрана профиля
extension UserProfileViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Профиль"
        
        setupLayout()
        setupActions()
    }
    
    private func setupLayout() {
        view.addSubview(avatarImageView)
        view.addSubview(userNameLabel)
        view.addSubview(userPhoneLabel)
        view.addSubview(addressCardView)
        view.addSubview(ecoBonusCardView)
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            // Блок аватара
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            avatarImageView.heightAnchor.constraint(equalToConstant: 90),
            
            // Имя пользователя
            userNameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            userNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Телефон пользователя
            userPhoneLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 4),
            userPhoneLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Карточка адреса
            addressCardView.topAnchor.constraint(equalTo: userPhoneLabel.bottomAnchor, constant: 32),
            addressCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addressCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addressCardView.heightAnchor.constraint(equalToConstant: 72),
            
            // Карточка эко-бонусов
            ecoBonusCardView.topAnchor.constraint(equalTo: addressCardView.bottomAnchor, constant: 16),
            ecoBonusCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ecoBonusCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ecoBonusCardView.heightAnchor.constraint(equalToConstant: 56),
            
            // Кнопка выхода привязана к низу экрана
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupActions() {
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
    }
    
    @objc private func logoutTapped() {
        let alert = UIAlertController(title: "Выйти из профиля?", message: "Вам придется заново вводить данные при оформлении заказа.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Выйти", style: .destructive) { _ in
            // Меняем статус авторизации в UserDefaults
            UserDefaults.standard.set(false, forKey: "menu_user_logged_in")
            
            // Закрываем экран или возвращаемся на главный
            self.navigationController?.popViewController(animated: true)
        })
        
        present(alert, animated: true)
    }
}

// MARK: - Canvas Preview для экрана профиля
#Preview {
    let profileVC = UserProfileViewController()
    return UINavigationController(rootViewController: profileVC)
}

