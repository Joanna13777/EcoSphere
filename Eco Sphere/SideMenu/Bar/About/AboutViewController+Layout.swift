import UIKit

extension AboutViewController {
    
    func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(logoImageView)
        contentView.addSubview(appNameLabel)
        contentView.addSubview(versionLabel)
        
        contentView.addSubview(missionCardView)
        missionCardView.addSubview(missionTitleLabel)
        missionCardView.addSubview(missionDescriptionLabel)
        
        contentView.addSubview(contactsTitleLabel)
        contentView.addSubview(phoneButton)
        contentView.addSubview(telegramButton)
        contentView.addSubview(emailButton)
        
        // 1. Констрейнты для контейнеров скролла
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
        
        // 2. Констрейнты элементов интерфейса (привязка к contentView)
        NSLayoutConstraint.activate([
            // Блок бренда (Логотип, Название, Версия)
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 28),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 72),
            logoImageView.heightAnchor.constraint(equalToConstant: 72),
            
            appNameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 12),
            appNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            versionLabel.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 4),
            versionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Карточка миссии
            missionCardView.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 32),
            missionCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            missionCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            missionTitleLabel.topAnchor.constraint(equalTo: missionCardView.topAnchor, constant: 16),
            missionTitleLabel.leadingAnchor.constraint(equalTo: missionCardView.leadingAnchor, constant: 16),
            missionTitleLabel.trailingAnchor.constraint(equalTo: missionCardView.trailingAnchor, constant: -16),
            
            missionDescriptionLabel.topAnchor.constraint(equalTo: missionTitleLabel.bottomAnchor, constant: 10),
            missionDescriptionLabel.leadingAnchor.constraint(equalTo: missionCardView.leadingAnchor, constant: 16),
            missionDescriptionLabel.trailingAnchor.constraint(equalTo: missionCardView.trailingAnchor, constant: -16),
            missionDescriptionLabel.bottomAnchor.constraint(equalTo: missionCardView.bottomAnchor, constant: -16),
            
            // Секция контактов
            contactsTitleLabel.topAnchor.constraint(equalTo: missionCardView.bottomAnchor, constant: 28),
            contactsTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            contactsTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            phoneButton.topAnchor.constraint(equalTo: contactsTitleLabel.bottomAnchor, constant: 14),
            phoneButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            phoneButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            phoneButton.heightAnchor.constraint(equalToConstant: 50),
            
            telegramButton.topAnchor.constraint(equalTo: phoneButton.bottomAnchor, constant: 10),
            telegramButton.leadingAnchor.constraint(equalTo: phoneButton.leadingAnchor),
            telegramButton.trailingAnchor.constraint(equalTo: phoneButton.trailingAnchor),
            telegramButton.heightAnchor.constraint(equalToConstant: 50),
            
            emailButton.topAnchor.constraint(equalTo: telegramButton.bottomAnchor, constant: 10),
            emailButton.leadingAnchor.constraint(equalTo: phoneButton.leadingAnchor),
            emailButton.trailingAnchor.constraint(equalTo: phoneButton.trailingAnchor),
            emailButton.heightAnchor.constraint(equalToConstant: 50),
            
            // ВАЖНО: Замыкаем на низ contentView для корректной работы вертикальной прокрутки
            emailButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }
}
