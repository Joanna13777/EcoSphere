import UIKit

class OnboardingCardViewController: UIViewController {
    
    let data: OnboardingPageModel
    var onSkipPressed: (() -> Void)?
    var onNextPressed: ((Int) -> Void)? // Строго принимает Int
    var onBackPressed: (() -> Void)?
    var onLanguageChangedGlobal: (() -> Void)?
    
    // UI Элементы
    private let backButton = UIButton(type: .system)
    private let languageButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let imageView = UIImageView()
    private let descriptionLabel = UILabel()
    private let skipButton = UIButton(type: .system)
    private let pageControl = UIPageControl()
    
    init(data: OnboardingPageModel) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if UserDefaults.standard.string(forKey: "app_lang") == nil {
            UserDefaults.standard.set("ru", forKey: "app_lang")
        }
        
        setupUI()
        updateTextForCurrentLanguage()
    }
    
    func refreshLanguage() {
        updateTextForCurrentLanguage()
    }
    
    // Здесь реализована вся логика смены флагов, переноса описания вниз к кнопке «Пропустить»/«Начать» и увеличения картинки
    private func updateTextForCurrentLanguage() {
        let currentLang = UserDefaults.standard.string(forKey: "app_lang") ?? "ru"
        
        // 1. Привязываем тексты заголовков и описаний
        if let translation = data.translations[currentLang] {
            titleLabel.text = translation.title
            descriptionLabel.text = translation.description
        }
        
        // 2. КНОПКИ ЯЗЫКА: устанавливаем флаг и текст черного цвета
        let flag: String
        switch currentLang {
        case "en": flag = "🇬🇧"
        case "uz": flag = "🇺🇿"
        default: flag = "🇷🇺" // ru
        }
        
        // Текст кнопки теперь формата "🇷🇺 RU", "🇺🇿 UZ" или "🇬🇧 EN"
        languageButton.setTitle("\(flag) \(currentLang.uppercased())", for: .normal)
        
        // 3.  КНОПКИ СНИЗУ: На последнем экране пишем "Начать", на остальных - "Пропустить"
        let isLastPage = (data.pageIndex == onboardingData.count - 1)
        
        if isLastPage {
            // ЭКРАН "Вывоз вторсырья": делаем кнопку акцентной и зеленой
            skipButton.setTitleColor(UIColor(red: 27/255, green: 94/255, blue: 32/255, alpha: 1), for: .normal)
            // Логика для экрана "Вывоз вторсырья"
            switch currentLang {
            case "uz": skipButton.setTitle("Boshlash", for: .normal)
            case "en": skipButton.setTitle("Get Started", for: .normal)
            default: skipButton.setTitle("Начать", for: .normal)
            }
        } else {
            // Логика для остальных экранов, делаем кнопку неброской и серой
            skipButton.setTitleColor(.systemGray, for: .normal)
            
            switch currentLang {
            case "uz": skipButton.setTitle("O'tkazib yuborish", for: .normal)
            case "en": skipButton.setTitle("Skip", for: .normal)
            default: skipButton.setTitle("Пропустить", for: .normal)
            }
        }
    }

    private func setupUI() {
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black // Сделаем стрелку назад тоже нейтрально-черной
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        backButton.isHidden = (data.pageIndex == 0)
        
        // ИСПРАВЛЕНИЕ КНОПКИ ЯЗЫКА: Текст черного цвета, контур убран
        var languageConfig = UIButton.Configuration.plain()
        languageConfig.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        languageButton.configuration = languageConfig
        languageButton.tintColor = .black // Цвет текста и флага теперь строго черный
        languageButton.layer.borderWidth = 0 // Убираем рамку/контур полностью
        languageButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        languageButton.addTarget(self, action: #selector(languageAction), for: .touchUpInside)
        
        // ЗАГОЛОВОК: Цвет заголовков теперь черного цвета
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .black // Меняем с зеленого на черный
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        //  КАРТИНКИ: Настройка для масштабирования
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        if let onboardingImage = UIImage(named: data.imageName) {
            imageView.image = onboardingImage
        }
        
        // Описание
        descriptionLabel.font = .systemFont(ofSize: 15, weight: .regular)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        
        // Кнопка Пропустить / Начать
        skipButton.setTitleColor(UIColor(red: 27/255, green: 94/255, blue: 32/255, alpha: 1), for: .normal) // "Начать" выделим фирменным зеленым, чтобы она смотрелась акцентно
        skipButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        skipButton.addTarget(self, action: #selector(skipAction), for: .touchUpInside)
        
        // Пагинация (точки)
        pageControl.numberOfPages = onboardingData.count
        pageControl.currentPage = data.pageIndex
        pageControl.currentPageIndicatorTintColor = UIColor(red: 27/255, green: 94/255, blue: 32/255, alpha: 1)
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.isUserInteractionEnabled = false // Оставляем индикатором для безопасности свайпов
        
        [backButton, languageButton, titleLabel, imageView, descriptionLabel, skipButton, pageControl].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        // ИСПРАВЛЕННЫЕ АДАПТИВНЫЕ КОНСТРЕИНТЫ СВЕРХУ ВНИЗ
        NSLayoutConstraint.activate([
            // 1. Верхняя панель (Назад и Язык)
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            
            languageButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            languageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            languageButton.heightAnchor.constraint(equalToConstant: 32),
            
            // 2. Черный заголовок экрана
            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            // 3. ИСПРАВЛЕНИЕ КАРТИНКИ: задаем безопасный размер и отступ от заголовка
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75), // 75% ширины экрана
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),             // Квадратные пропорции 1:1
            
            // 4. ИСПРАВЛЕНИЕ ОПИСАНИЯ: убираем centerYAnchor, привязываем строго под картинкой
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            // Нижняя граница текста не должна наползать на кнопку управления
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: skipButton.topAnchor, constant: -16),
            
            // 5. Серая кнопка "Пропустить" / Зеленая "Начать"
            skipButton.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -24),
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skipButton.heightAnchor.constraint(equalToConstant: 44),
            
            // 6. Точки пагинации в самом низу
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

    }

    
    @objc private func pageControlValueChanges(_ sender: UIPageControl) {
        let targetPage = sender.currentPage
        if targetPage >= 0 && targetPage < onboardingData.count {
            onNextPressed?(sender.currentPage)
        }
    }
    @objc private func languageAction() {
        let currentLang = UserDefaults.standard.string(forKey: "app_lang") ?? "ru"
        let nextLang: String
        switch currentLang {
        case "ru": nextLang = "uz"
        case "uz": nextLang = "en"
        default: nextLang = "ru"
        }
        UserDefaults.standard.set(nextLang, forKey: "app_lang")
        UserDefaults.standard.set([nextLang], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        updateTextForCurrentLanguage()
        onLanguageChangedGlobal?()
    }
    
    @objc private func backAction() { onBackPressed?() }
    @objc private func skipAction() { onSkipPressed?() }
}
//#Preview {
//   
//    
//    
//}
