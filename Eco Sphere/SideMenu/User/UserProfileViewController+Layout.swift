import UIKit

extension UserProfileViewController {
    
    // Создаем скролл-контейнеры прямо в расширении
    private static let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.alwaysBounceVertical = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private static let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Основной метод для сборки интерфейса профиля
    func setupLayout() {
        let scrollView = Self.scrollView
        let contentView = Self.contentView
        
        // 1. Иерархия добавления элементов
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userPhoneLabel)
        contentView.addSubview(addressCardView)
        contentView.addSubview(ecoBonusCardView)
        contentView.addSubview(logoutButton)
        
        // Настройка скругления аватара (100x100 / 2 = 50 для идеального круга)
        avatarImageView.layer.cornerRadius = 50
        
        // 2. Констрейнты для ScrollView и ContentView
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
        
        // 3. Констрейнты для элементов профиля (привязка к contentView)
        NSLayoutConstraint.activate([
            // Аватар по центру сверху
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),
            
            // Имя пользователя
            userNameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 16),
            userNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Телефон пользователя
            userPhoneLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 6),
            userPhoneLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Карточка адреса
            addressCardView.topAnchor.constraint(equalTo: userPhoneLabel.bottomAnchor, constant: 32),
            addressCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            addressCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Карточка эко-бонусов
            ecoBonusCardView.topAnchor.constraint(equalTo: addressCardView.bottomAnchor, constant: 16),
            ecoBonusCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ecoBonusCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ecoBonusCardView.heightAnchor.constraint(equalToConstant: 72), // Фиксированная высота для баланса
            
            // Кнопка выхода (В самом низу с отступом)
            logoutButton.topAnchor.constraint(equalTo: ecoBonusCardView.bottomAnchor, constant: 40),
            logoutButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Замыкаем нижний констрейнт на контейнер для активации скролла
            logoutButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }
}
