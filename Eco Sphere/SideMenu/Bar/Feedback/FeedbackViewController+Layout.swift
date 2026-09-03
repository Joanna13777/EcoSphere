import UIKit

extension FeedbackViewController {
    
    func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(categoryTextField)
        contentView.addSubview(messageTextView)
        contentView.addSubview(sendButton)
        
        // 1. Констрейнты для скролла
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
        
        // 2. Констрейнты для элементов формы (привязка к contentView)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            categoryTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            categoryTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            categoryTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            categoryTextField.heightAnchor.constraint(equalToConstant: 48),
            
            messageTextView.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 16),
            messageTextView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            messageTextView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            messageTextView.heightAnchor.constraint(equalToConstant: 160), // Высота текстового блока обращения
            
            sendButton.topAnchor.constraint(equalTo: messageTextView.bottomAnchor, constant: 28),
            sendButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            sendButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 52),
            
            // ВАЖНО: Замыкаем на низ contentView для активации скролла
            sendButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
}
