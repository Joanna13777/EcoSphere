import UIKit

class LanguageViewController: UIViewController {
    
    // MARK: - UI Elements
    private let mainImageView = UIImageView()
    private let buttonStackView = UIStackView()
    private let enButton = UIButton(type: .system)
    private let ruButton = UIButton(type: .system)
    private let uzButton = UIButton(type: .system)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupImage()
        setupButtons()
        setupLayout()
    }
    
    // MARK: - UI Setup
    private func setupImage() {
        // Загрузка изображения eco_onb напрямую из Assets.xcassets
        mainImageView.image = UIImage(named: "eco_onb")
//        mainImageView.contentMode = .scaleAspectFit
    }
    
    private func setupButtons() {
        buttonStackView.axis = .vertical
        buttonStackView.spacing = 16
        buttonStackView.distribution = .fillEqually
        
        configureLanguageButton(enButton, title: "English", langCode: "en")
        configureLanguageButton(ruButton, title: "Русский", langCode: "ru")
        configureLanguageButton(uzButton, title: "O'zbekcha", langCode: "uz")
    }
    
    private func configureLanguageButton(_ button: UIButton, title: String, langCode: String) {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.baseBackgroundColor = UIColor(red: 27/255, green: 94/255, blue: 32/255, alpha: 1) // Фирменный зеленый
        config.baseForegroundColor = .white
        config.cornerStyle = .medium
        
        button.configuration = config
        button.accessibilityIdentifier = langCode
        button.addTarget(self, action: #selector(languageButtonTapped(_:)), for: .touchUpInside)
        
        buttonStackView.addArrangedSubview(button)
    }
    
    private func setupLayout() {
        [mainImageView, buttonStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // Констреинты для изображения eco_onb (сверху с отступами)
            mainImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            mainImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            mainImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            mainImageView.heightAnchor.constraint(equalToConstant: 240), // Ограничение высоты для аккуратного рендеринга
            
            // Констреинты для блока кнопок выбора языка (снизу экрана)
            buttonStackView.topAnchor.constraint(greaterThanOrEqualTo: mainImageView.bottomAnchor, constant: 20),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            buttonStackView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    // MARK: - Actions
    @objc private func languageButtonTapped(_ sender: UIButton) {
        guard let langCode = sender.accessibilityIdentifier else { return }
        languageSelected(langCode: langCode)
    }
    
    private func languageSelected(langCode: String) {
        // Запись выбранной локали
        UserDefaults.standard.set([langCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        // Так как этот экран доступен ТОЛЬКО при первом запуске, мы гарантированно пушим OnboardingViewController
        let onboardingVC = OnboardingViewController()
        navigationController?.pushViewController(onboardingVC, animated: true)
    }
}
