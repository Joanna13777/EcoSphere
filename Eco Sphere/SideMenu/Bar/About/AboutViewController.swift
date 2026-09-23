// экран «О приложении» объявлены только UI-компоненты и методы жизненного цикла.

import UIKit

class AboutViewController: UIViewController {
    
    // MARK: - UI Containers
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = true
        scroll.alwaysBounceVertical = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Legal Header
    let infoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "checkmark.shield.fill")
        iv.tintColor = .secondaryLabel
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let mainTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Условия и правила"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .appText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Legal Sections
    lazy var introBody = AboutViewController.createSectionLabel(text: "Настоящее Пользовательское соглашение регулирует отношения между эко-сервисом Eco Sphere (далее — Компания) и физическим лицом (далее — Пользователь), использующим приложение для заказа вывоза вторичного сырья в городе Ташкенте.")
    lazy var userTitle = AboutViewController.createSectionLabel(text: "1. Обязанности Пользователя", isTitle: true)
    lazy var userBody = AboutViewController.createSectionLabel(text: "• Осуществлять предварительную сортировку отходов согласно правилам приложения (очищать пластик от остатков пищи, разделять макулатуру и стекло).\n• Указывать достоверный адрес и контактный номер телефона в профиле.\n• Обеспечить доступ курьера или спецтранспорта к указанному месту сбора в согласованный временной интервал.\n• Не передавать к вывозу опасные, токсичные или медицинские отходы.")
    lazy var companyTitle = AboutViewController.createSectionLabel(text: "2. Обязанности Компании", isTitle: true)
    lazy var companyBody = AboutViewController.createSectionLabel(text: "• Своевременно обрабатывать заявки на вывоз вторсырья и направлять транспорт в выбранный пользователем интервал.\n• Начислять Эко-бонусы в полном объеме сразу после успешной проверки и взвешивания сданного сырья.\n• Гарантировать, что все собранные отходы будут направлены исключительно на сертифицированные заводы по переработке в Узбекистане.\n• Обеспечивать конфиденциальность и защиту персональных данных профиля.")
    
    // MARK: - Карточка-резюме
    let agreementCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        view.layer.cornerRadius = 14
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "🤝 Используя приложение Eco Sphere и отправляя заявки на вывоз, обе стороны автоматически соглашаются с данными правилами и обязуются соблюдать их ради чистой экологии нашей столицы."
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 14),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -14)
        ])
        
        return view
    }()
    
    // MARK: - Interactive Agreement Elements
    let agreementLabel: UILabel = {
        let label = UILabel()
        label.text = "Я подтверждаю, что ознакомлен и полностью согласен с условиями оферты"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .appText
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let agreementSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = .systemGreen
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    let acceptButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.background.cornerRadius = 14
        var titleAttr = AttributedString("Подтвердить согласие")
        titleAttr.font = .systemFont(ofSize: 15, weight: .semibold)
        config.attributedTitle = titleAttr
        
        let button = UIButton(configuration: config)
        button.configurationUpdateHandler = { btn in
            var updatedConfig = btn.configuration
            if !btn.isEnabled {
                updatedConfig?.baseBackgroundColor = .systemGray5
                updatedConfig?.baseForegroundColor = .systemGray2
            } else {
                updatedConfig?.baseBackgroundColor = .label
                updatedConfig?.baseForegroundColor = .systemBackground
            }
            btn.configuration = updatedConfig
        }
        
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let alreadyAcceptedLabel: UILabel = {
        let label = UILabel()
        label.text = "✅ Вы дали согласие с подтверждением условий оферты"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemGreen
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        checkAgreementStatus()
    }
    
    // MARK: - Helpers (Factory Method)
    static func createSectionLabel(text: String, isTitle: Bool = false) -> UILabel {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        if isTitle {
            label.font = .systemFont(ofSize: 16, weight: .bold)
            label.textColor = .label
        } else {
            label.font = .systemFont(ofSize: 14, weight: .regular)
            label.textColor = .appText
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            label.attributedText = attributedString
        }
        return label
    }
}
