// Экран зарегистрированного пользователя с объявлением UI-элементов и адаптивной темой

import UIKit

class UserProfileViewController: UIViewController {
    
    // MARK: - UI Элементы верхнего блока (Аватар и Имя)
    let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person.crop.circle.fill")
        // Заменили жесткий темно-серый на адаптивный системный цвет
        iv.tintColor = .systemGray3
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Иван Иванов"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .appText // Наш адаптивный цвет текста
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let userPhoneLabel: UILabel = {
        let label = UILabel()
        label.text = "+998 90 123 45 67"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .appSecondaryText // Наш адаптивный серый текст
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Информационные карточки (Адрес и Бонусы)
    let addressCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .appCardBackground // Адаптивный фон для карточек
        view.layer.cornerRadius = 14
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.appSeparator.cgColor // Адаптивная рамка
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let icon = UIImageView(image: UIImage(systemName: "mappin.circle.fill"))
        icon.tintColor = .appSecondaryText
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        let title = UILabel()
        title.text = "Основной адрес доставки"
        title.font = .systemFont(ofSize: 12, weight: .regular)
        title.textColor = .appSecondaryText
        title.translatesAutoresizingMaskIntoConstraints = false
        
        let value = UILabel()
        value.text = "ул. Амира Темура, дом 14, кв. 25"
        value.font = .systemFont(ofSize: 15, weight: .medium)
        value.textColor = .appText // ИСПРАВЛЕНО: Заменили .black на адаптивный текст, чтобы он не пропадал в темной теме
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
        view.backgroundColor = .systemGreen.withAlphaComponent(0.08) // Мягкий адаптивный зеленый фон
        view.layer.cornerRadius = 14
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.customReminderBorder.cgColor // Наша адаптивная зеленая рамка
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let icon = UIImageView(image: UIImage(systemName: "leaf.circle.fill"))
        icon.tintColor = .systemGreen
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        let title = UILabel()
        title.text = "Эко-бонусы"
        title.font = .systemFont(ofSize: 13, weight: .medium)
        title.textColor = .customReminderText // Адаптивный темно-зеленый текст
        title.translatesAutoresizingMaskIntoConstraints = false
        
        let score = UILabel()
        score.text = "1,250 Б"
        score.font = .systemFont(ofSize: 22, weight: .bold)
        score.textColor = .customReminderText // Адаптивный зеленый счет
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupThemeObserver() // Запуск автоматического отслеживания темы для CGColor рамок
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Красим системный навигационный бар и подложку экрана под текущую тему приложения
        UIColor.applyGlobalTheme(for: self)
    }
    
    // MARK: - Логика динамического изменения темы (iOS 17+)
    private func setupThemeObserver() {
        if #available(iOS 17.0, *) {
            registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (vc: UserProfileViewController, _) in
                vc.refreshLayers()
            }
        }
    }
    
    private func refreshLayers() {
        addressCardView.layer.borderColor = UIColor.appSeparator.cgColor
        ecoBonusCardView.layer.borderColor = UIColor.customReminderBorder.cgColor
    }
    
    @available(iOS, deprecated: 17.0, message: "Use registerForTraitChanges instead")
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 17.0, *) { return }
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            refreshLayers()
        }
    }
}
