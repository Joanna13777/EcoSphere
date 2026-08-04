import UIKit

class OnboardingCardViewController: UIViewController {
    
    // MARK: - Данные и Обработка действий (Callbacks)
    let data: OnboardingPageModel
    var onSkipPressed: (() -> Void)?
    var onNextPressed: ((Int) -> Void)?
    var onBackPressed: (() -> Void)?
    var onLanguageChangedGlobal: (() -> Void)?
    
    // MARK: - UI Элементы
    let backButton = UIButton(type: .system)
    let languageButton = UIButton(type: .system)
    let titleLabel = UILabel()
    let imageView = UIImageView()
    let descriptionLabel = UILabel()
    let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let pageControl = UIPageControl()
    
    // Кнопка стала чистой, стили накладываются динамически в логике
    let registrationButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Инициализация
    init(data: OnboardingPageModel) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Жизненный цикл (Lifecycle)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if UserDefaults.standard.string(forKey: "app_lang") == nil {
            UserDefaults.standard.set("ru", forKey: "app_lang")
        }
        
        setupUI()
        updateTextForCurrentLanguage()
    }
}
