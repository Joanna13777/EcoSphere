import UIKit

extension EditProfileViewController {
    
    func setupLayout() {
        // 1. Собираем структуру иерархии
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(changeAvatarButton)
        
        contentView.addSubview(nameTextField)
        contentView.addSubview(surnameTextField)
        contentView.addSubview(cityTextField)
        contentView.addSubview(addressTextField)
        contentView.addSubview(phoneTextField)
        contentView.addSubview(emailTextField)
        contentView.addSubview(saveButton)
        contentView.addSubview(navigateToLoginButton)
        
        // Округляем фото
        avatarImageView.layer.cornerRadius = 50
        
        // 2. Констрейнты скролла
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // 3. Констрейнты элементов формы ввода (привязка к contentView)
                NSLayoutConstraint.activate([
                    avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
                    avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                    avatarImageView.widthAnchor.constraint(equalToConstant: 100),
                    avatarImageView.heightAnchor.constraint(equalToConstant: 100),
                    
                    changeAvatarButton.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
                    changeAvatarButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                    
                    nameTextField.topAnchor.constraint(equalTo: changeAvatarButton.bottomAnchor, constant: 24),
                    nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                    nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                    nameTextField.heightAnchor.constraint(equalToConstant: 48),
                    
                    surnameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 12),
                    surnameTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
                    surnameTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
                    surnameTextField.heightAnchor.constraint(equalToConstant: 48),
                    
                    cityTextField.topAnchor.constraint(equalTo: surnameTextField.bottomAnchor, constant: 12),
                    cityTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
                    cityTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
                    cityTextField.heightAnchor.constraint(equalToConstant: 48),
                    
                    addressTextField.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 12),
                    addressTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
                    addressTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
                    addressTextField.heightAnchor.constraint(equalToConstant: 48),
                    
                    phoneTextField.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 12),
                    phoneTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
                    phoneTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
                    phoneTextField.heightAnchor.constraint(equalToConstant: 48),
                    
                    emailTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 12),
                    emailTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
                    emailTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
                    emailTextField.heightAnchor.constraint(equalToConstant: 48),
                    
                    saveButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 28),
                    saveButton.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
                    saveButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
                    saveButton.heightAnchor.constraint(equalToConstant: 52),
                    
                    navigateToLoginButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 16),
                    navigateToLoginButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                    navigateToLoginButton.leadingAnchor.constraint(equalTo: saveButton.leadingAnchor),
                    navigateToLoginButton.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor),
                    navigateToLoginButton.heightAnchor.constraint(equalToConstant: 30), // Задаем высоту для удобного тапа
                    
                    // замыкаем низ contentView на самую последнюю кнопку-ссылку!
                    navigateToLoginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
                ])

    }
}
