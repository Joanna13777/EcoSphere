import UIKit

extension FeedbackViewController {
    
    func setupLayout() {
        // 1. Сначала СТРОГО добавляем абсолютно все элементы в иерархию View!
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(categoryTextField)
        contentView.addSubview(messageTextView)
        
        // 🌟 ВОТ ОНО ИСПРАВЛЕНИЕ: Обязательно добавляем новые элементы на contentView до констрейнтов!
        contentView.addSubview(attachFileButton)
        contentView.addSubview(previewImageView)
        
        contentView.addSubview(sendButton)
        
        // 2. И только ПОСЛЕ этого активируем констрейнты
        NSLayoutConstraint.activate([
            // Констрейнты для контейнеров скролла
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
        
        // Констрейнты элементов формы (Идеальное выравнивание по ширине)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Поле темы обращения
            categoryTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            categoryTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            categoryTextField.heightAnchor.constraint(equalToConstant: 48),
            
            // Поле ввода сообщения (Теперь строго повторяет левую и правую границы поля темы!)
            messageTextView.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 16),
            messageTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            messageTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            messageTextView.heightAnchor.constraint(equalToConstant: 140),
            
            // Кнопка скрепки под текстовым полем
            attachFileButton.topAnchor.constraint(equalTo: messageTextView.bottomAnchor, constant: 12),
            attachFileButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            // Превью картинки
            previewImageView.centerYAnchor.constraint(equalTo: attachFileButton.centerYAnchor),
            previewImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            previewImageView.widthAnchor.constraint(equalToConstant: 40),
            previewImageView.heightAnchor.constraint(equalToConstant: 40),
            
            // Кнопка "Отправить"
            sendButton.topAnchor.constraint(equalTo: attachFileButton.bottomAnchor, constant: 20),
            sendButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sendButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            sendButton.heightAnchor.constraint(equalToConstant: 52),
            
            sendButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }

}
