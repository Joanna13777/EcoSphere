// экран «О приложении» (AboutViewController.swift)Этот экран будет содержать официальную информацию, Правила использования сервиса, обязанности сторон (пользователя и компании) и встроенный блок соглашения (публичную оферту)

import UIKit

class AboutViewController: UIViewController {
    
    // MARK: - UI Elements (Containers)
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
    
    // MARK: - Header
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
    
    // MARK: - Legal Text Blocks (Clean Lazy Implementation)
    
    lazy var introBody: UILabel = {
        let label = UILabel()
        let text = "Настоящее Пользовательское соглашение регулирует отношения между эко-сервисом Eco Sphere (далее — Компания) и физическим лицом (далее — Пользователь), использующим приложение для заказа вывоза вторичного сырья в городе Ташкенте."
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .appText
        label.numberOfLines = 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var userTitle: UILabel = {
        let label = UILabel()
        label.text = "1. Обязанности Пользователя"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var userBody: UILabel = {
        let label = UILabel()
        let text = "• Осуществлять предварительную сортировку отходов согласно правилам приложения (очищать пластик от остатков пищи, разделять макулатуру и стекло).\n• Указывать достоверный адрес и контактный номер телефона в профиле.\n• Обеспечить доступ курьера или спецтранспорта к указанному месту сбора в согласованный временной интервал.\n• Не передавать к вывозу опасные, токсичные или медицинские отходы."
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .appText
        label.numberOfLines = 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var companyTitle: UILabel = {
        let label = UILabel()
        label.text = "2. Обязанности Компании"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var companyBody: UILabel = {
        let label = UILabel()
        let text = "• Своевременно обрабатывать заявки на вывоз вторсырья и направлять транспорт в выбранный пользователем интервал.\n• Начислять Эко-бонусы в полном объеме сразу после успешной проверки и взвешивания сданного сырья.\n• Гарантировать, что все собранные отходы будут направлены исключительно на сертифицированные заводы по переработке в Узбекистане.\n• Обеспечивать конфиденциальность и защиту персональных данных профиля."
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .appText
        label.numberOfLines = 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let AgreementCardView: UIView = {
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayout() // Вызовется из файла +Layout.swift
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIColor.applyGlobalTheme(for: self)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
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
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}
