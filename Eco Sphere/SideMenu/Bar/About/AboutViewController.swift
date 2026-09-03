import UIKit

class AboutViewController: UIViewController {
    
    // MARK: - UI Elements (Containers)
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.alwaysBounceVertical = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Logo & Brand
    let logoImageView: UIImageView = {
        let iv = UIImageView()
        // Фирменная адаптивная иконка (зеленый листок в круге)
        iv.image = UIImage(systemName: "leaf.circle.fill")
        iv.tintColor = .systemGreen
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Eco Sphere"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .appText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let versionLabel: UILabel = {
        let label = UILabel()
        label.text = "Версия 1.0.0"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .appSecondaryText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Mission Card
    let missionCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen.withAlphaComponent(0.06)
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.customReminderBorder.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let missionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Наша эко-миссия в Ташкенте"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .customReminderText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let missionDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Мы стремимся сделать Ташкент чище и зеленее, превращая процесс сдачи вторсырья в простую и приятную привычку. Eco Sphere объединяет жителей города и пункты переработки, помогая сократить количество отходов и заботиться о будущем нашей столицы шаг за шагом."
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .appText
        label.numberOfLines = 0
        
        // Настройка межстрочного интервала для красивого чтения текста
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        let attributedString = NSMutableAttributedString(string: label.text ?? "")
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Contacts Section
    let contactsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Связаться с нами"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .appText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Интерактивные кнопки связи
    lazy var phoneButton = AboutViewController.createContactButton(title: "+998 90 345 37 26", iconName: "phone.fill", color: .systemGreen)
    lazy var telegramButton = AboutViewController.createContactButton(title: "@tashkent_recycle", iconName: "paperplane.fill", color: .systemBlue)
    lazy var emailButton = AboutViewController.createContactButton(title: "info@ecosphere@list.ru", iconName: "envelope.fill", color: .systemOrange)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayout() // Вызов из файла +Layout.swift
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIColor.applyGlobalTheme(for: self)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        // Обновляем CGColor зеленой рамки карточки принудительно для темной/светлой темы
        missionCardView.layer.borderColor = UIColor.customReminderBorder.cgColor
    }
    
    // MARK: - Setups
    private func setupNavigationBar() {
        title = "О приложении"
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .appText
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func setupActions() {
        phoneButton.addTarget(self, action: #selector(phoneTapped), for: .touchUpInside)
        telegramButton.addTarget(self, action: #selector(telegramTapped), for: .touchUpInside)
        emailButton.addTarget(self, action: #selector(emailTapped), for: .touchUpInside)
        
        if #available(iOS 17.0, *) {
            registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (vc: AboutViewController, _) in
                vc.missionCardView.layer.borderColor = UIColor.customReminderBorder.cgColor
            }
        }
    }
    
    // MARK: - Interactive Contact Handlers (Реальное открытие внешних приложений)
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func phoneTapped() {
        // Системный вызов звонилки iPhone
        if let url = URL(string: "tel://+998903453726"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc private func telegramTapped() {
        // Открытие Telegram-профиля или канала компании
        if let url = URL(string: "https://t.me/+IShmNAlNsOQ2MDEy") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Если Telegram не установлен, открываем его через обычный веб-браузер
                if let webUrl = URL(string: "https://t.me/+IShmNAlNsOQ2MDEy") {
                    UIApplication.shared.open(webUrl, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    @objc private func emailTapped() {
        // Системное открытие почтового клиента
        if let url = URL(string: "mailto:info@ecosphere@list.ru"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - Factory Method (Кнопки контактов)
    private static func createContactButton(title: String, iconName: String, color: UIColor) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = .systemGroupedBackground
        config.background.cornerRadius = 12
        
        var titleAttr = AttributedString(title)
        titleAttr.font = .systemFont(ofSize: 15, weight: .medium)
        titleAttr.foregroundColor = .appText
        config.attributedTitle = titleAttr
        
        config.image = UIImage(systemName: iconName)
        config.imagePadding = 12
        config.imagePlacement = .leading
        config.baseForegroundColor = color
        config.contentInsets = NSDirectionalEdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16)
        
        let button = UIButton(configuration: config)
        button.contentHorizontalAlignment = .leading // Выравнивание иконки и текста по левому краю
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
