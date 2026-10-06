import UIKit

// MARK: - Auto Layout для экрана деталей заказа
extension OrderDetailViewController {
    
    func setupLayout() {
        view.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(infoLabel)
        containerView.addSubview(statusLabel)
        view.addSubview(actionButton)
        
        titleLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            // Белая/темная карточка по центру экрана
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Крупная иконка типа отхода внутри карточки
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 72),
            iconImageView.heightAnchor.constraint(equalToConstant: 72),
            
            // Название вида отхода
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            // Текстовый блок параметров (Вес, Дата, Адрес)
            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            infoLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            infoLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            // Строка текущего статуса
            statusLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 24),
            statusLabel.leadingAnchor.constraint(equalTo: infoLabel.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: infoLabel.trailingAnchor),
            statusLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
            
            // Нижняя фиксированная кнопка действий
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            actionButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
}
