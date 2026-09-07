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
        
        contentView.addSubview(AgreementCardView)
        
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
            
            // Карточка-резюме соглашения
            AgreementCardView.topAnchor.constraint(equalTo: companyBody.bottomAnchor, constant: 28),
            AgreementCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            AgreementCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Замыкаем на низ contentView, чтобы договор можно было плавно прокручивать пальцем
            AgreementCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }
}
