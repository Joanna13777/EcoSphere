import UIKit

extension ArticleDetailViewController {
    
    func setupLayout() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(textLabel)
        contentView.addSubview(articleImageView)
        
        let imageHeight = articleImageView.heightAnchor.constraint(equalToConstant: 180)
        imageHeight.priority = .defaultHigh
        imageHeight.isActive = true
        
        
        // Создаем резервный констрейнт для текста на случай, если картинки нет
        noImageBottomConstraint = textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        noImageBottomConstraint.priority = .defaultLow // Низкий приоритет, чтобы не конфликтовать по умолчанию
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            noImageBottomConstraint, // Включаем резервный констрейнт низа текста
            
            articleImageView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 20),
            articleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            articleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Основной низ контента привязан к картинке
            articleImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
}
