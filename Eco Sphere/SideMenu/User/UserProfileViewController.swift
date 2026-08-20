// Экран рарегистрипрованного пользователя только с объявлением UI-элементов

import UIKit

class UserProfileViewController: UIViewController {
    
    // MARK: - UI Элементы верхнего блока (Аватар и Имя)
    let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person.crop.circle.fill")
        iv.tintColor = UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1.0)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Иван Иванов"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let userPhoneLabel: UILabel = {
        let label = UILabel()
        label.text = "+998 90 123 45 67"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Информационные карточки (Адрес и Бонусы)
    let addressCardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.0)
        view.layer.cornerRadius = 14
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let icon = UIImageView(image: UIImage(systemName: "mappin.circle.fill"))
        icon.tintColor = .systemGray
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        let title = UILabel()
        title.text = "Основной адрес доставки"
        title.font = .systemFont(ofSize: 12, weight: .regular)
        title.textColor = .systemGray
        title.translatesAutoresizingMaskIntoConstraints = false
        
        let value = UILabel()
        value.text = "ул. Амира Темура, дом 14, кв. 25"
        value.font = .systemFont(ofSize: 15, weight: .medium)
        value.textColor = .black
        value.numberOfLines = 2
        value.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(icon)
        view.addSubview(title)
        view.addSubview(value)
        
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            icon.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 24),
            icon.heightAnchor.constraint(equalToConstant: 24),
            
            title.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 12),
            title.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            title.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            
            value.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            value.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            value.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 4),
            value.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12)
        ])
        
        return view
    }()
    
    let ecoBonusCardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.96, green: 0.98, blue: 0.96, alpha: 1.0) // Эко-зеленый
        view.layer.cornerRadius = 14
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.85, green: 0.90, blue: 0.85, alpha: 1.0).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let icon = UIImageView(image: UIImage(systemName: "leaf.circle.fill"))
        icon.tintColor = UIColor(red: 0.27, green: 0.54, blue: 0.35, alpha: 1.0)
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        let title = UILabel()
        title.text = "Эко-бонусы"
        title.font = .systemFont(ofSize: 13, weight: .medium)
        title.textColor = UIColor(red: 0.15, green: 0.25, blue: 0.18, alpha: 1.0)
        title.translatesAutoresizingMaskIntoConstraints = false
        
        let score = UILabel()
        score.text = "1,250 Б"
        score.font = .systemFont(ofSize: 22, weight: .bold)
        score.textColor = UIColor(red: 0.27, green: 0.54, blue: 0.35, alpha: 1.0)
        score.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(icon)
        view.addSubview(title)
        view.addSubview(score)
        
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            icon.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            icon.widthAnchor.constraint(equalToConstant: 24),
            icon.heightAnchor.constraint(equalToConstant: 24),
            
            title.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 12),
            title.centerYAnchor.constraint(equalTo: icon.centerYAnchor),
            
            score.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            score.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }()
    
    // MARK: - Кнопка Выйти из аккаунта
    let logoutButton: UIButton = {
        var config = UIButton.Configuration.plain()
        
        var titleAttr = AttributedString("Выйти из аккаунта")
        titleAttr.font = .systemFont(ofSize: 15, weight: .medium)
        config.attributedTitle = titleAttr
        
        config.baseForegroundColor = .systemRed
        config.image = UIImage(systemName: "rectangle.portrait.and.arrow.right")
        config.imagePadding = 8
        config.imagePlacement = .leading
        
        let button = UIButton(configuration: config, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}
