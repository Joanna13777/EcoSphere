import UIKit

extension AboutViewController {
    
    func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(infoImageView)
        contentView.addSubview(mainTitleLabel)
        contentView.addSubview(introBody)
        
        contentView.addSubview(userTitle)
        contentView.addSubview(userBody)
        
        contentView.addSubview(companyTitle)
        contentView.addSubview(companyBody)
        
        // Встраиваем карточку-резюме и элементы подтверждения
                contentView.addSubview(agreementCardView)
                contentView.addSubview(agreementLabel)
                contentView.addSubview(agreementSwitch)
                contentView.addSubview(acceptButton)
        contentView.addSubview(alreadyAcceptedLabel)
        
        // 1. Констрейнты скролл-контейнеров
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
        
        // 2. Последовательный спуск контента договора сверху вниз
        NSLayoutConstraint.activate([
            // верхний отступ иконки
            infoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            infoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            infoImageView.widthAnchor.constraint(equalToConstant: 44),
            infoImageView.heightAnchor.constraint(equalToConstant: 44),
            
            // Подтягиваем главный заголовок
            mainTitleLabel.topAnchor.constraint(equalTo: infoImageView.bottomAnchor, constant: 8),
            mainTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Подтягиваем вводный текст ближе к заголовку
            introBody.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 12),
            introBody.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            introBody.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Раздел 1 (Пользователь)
            userTitle.topAnchor.constraint(equalTo: introBody.bottomAnchor, constant: 20), // уменьшено с 24
            userTitle.leadingAnchor.constraint(equalTo: introBody.leadingAnchor),
            userTitle.trailingAnchor.constraint(equalTo: introBody.trailingAnchor),
            
            userBody.topAnchor.constraint(equalTo: userTitle.bottomAnchor, constant: 8),
            userBody.leadingAnchor.constraint(equalTo: introBody.leadingAnchor),
            userBody.trailingAnchor.constraint(equalTo: introBody.trailingAnchor),
            
            // Раздел 2 (Компания)
            companyTitle.topAnchor.constraint(equalTo: userBody.bottomAnchor, constant: 24),
            companyTitle.leadingAnchor.constraint(equalTo: introBody.leadingAnchor),
            companyTitle.trailingAnchor.constraint(equalTo: introBody.trailingAnchor),
            
            companyBody.topAnchor.constraint(equalTo: companyTitle.bottomAnchor, constant: 8),
            companyBody.leadingAnchor.constraint(equalTo: introBody.leadingAnchor),
            companyBody.trailingAnchor.constraint(equalTo: introBody.trailingAnchor),
            
            // КАРТОЧКА-РЕЗЮМЕ ИЗ СКРИНШОТА: Размещается строго под текстом правил
                        agreementCardView.topAnchor.constraint(equalTo: companyBody.bottomAnchor, constant: 24),
                        agreementCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                        agreementCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                        
                        // СТРОКА ТУМБЛЕРА СОГЛАСИЯ: Размещается под карточкой-резюме
                        agreementSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                        agreementSwitch.topAnchor.constraint(equalTo: agreementCardView.bottomAnchor, constant: 24),
                        agreementSwitch.widthAnchor.constraint(equalToConstant: 51),
                        
                        agreementLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                        agreementLabel.trailingAnchor.constraint(equalTo: agreementSwitch.leadingAnchor, constant: -12),
                        agreementLabel.centerYAnchor.constraint(equalTo: agreementSwitch.centerYAnchor),
                        
                        // КНОПКА ПОДТВЕРЖДЕНИЯ
                        acceptButton.topAnchor.constraint(equalTo: agreementLabel.bottomAnchor, constant: 24),
                        acceptButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                        acceptButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                        acceptButton.heightAnchor.constraint(equalToConstant: 52),
            
            // СТАТИЧНЫЙ БЛОК: Размещение новой надписи под карточкой-резюме
                        alreadyAcceptedLabel.topAnchor.constraint(equalTo: agreementCardView.bottomAnchor, constant: 28),
                        alreadyAcceptedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                        alreadyAcceptedLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                        
                        // ГЛАВНОЕ УСЛОВИЕ СКРОЛЛА: Привязываем к низу contentView оба элемента с разным приоритетом!
                        // Это позволит скроллу работать правильно независимо от того, какой элемент скрыт на экране
                        acceptButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32).withPriority(.defaultHigh),
                        alreadyAcceptedLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32).withPriority(.defaultLow)
        ])
    }
}

// Вспомогательное расширение для удобной смены приоритетов констрейнтов в коде
extension NSLayoutConstraint {
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
