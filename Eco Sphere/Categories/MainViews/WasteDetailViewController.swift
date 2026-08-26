// экран-шаблон с описанием

import UIKit

class WasteDetailViewController: UIViewController {
    
    // Свойство для получения данных из PageViewController
    var wasteData: WasteType? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Палитра цветов
    private let accentYellowColor = UIColor.appAccent
    
    //    // MARK: - Палитра цветов
    //    private let appBgColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0) // #F5F5F5
    //    private let darkTextColor = UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0) // #1A1A1A
    //    private let secondaryTextColor = UIColor(red: 0.49, green: 0.49, blue: 0.49, alpha: 1.0) // #7E7E7E
    //    private let accentYellowColor = UIColor.appAccent // #F4B41A (Яркий желтый)
    
    // MARK: - UI-Элементы
    
    // 1. Главная белая карточка-подложка для контента
    private let mainCardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 28
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.03
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.layer.shadowRadius = 16
        view.backgroundColor = .appCardBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Скролл-контейнер (чтобы на маленьких экранах текст не обрезался)
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let cardContentView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // Измененный ImageView (теперь это аккуратное центрированное лого материала)
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true  // Обрезаем края картинки, чтобы они не вылезали за контур карточки
        iv.layer.cornerRadius = 16 // Делаем небольшое скругление углов самой картинки для эстетики
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // Описание принимаемых предметов (Сетка/Список)
    private let shortDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Вертикальный стек для карточек с правилами (вместо fullDescriptionLabel)
    private let rulesStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBackground
        
        setupLayout()
        updateUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIColor.applyGlobalTheme(for: self)
        
        mainCardView.backgroundColor = .appCardBackground
        shortDescriptionLabel.textColor = .label
    }
    
    // MARK: - Наполнение данными
    private func updateUI() {
        guard isViewLoaded, let data = wasteData else { return }
        
        let isDark = UserDefaults.standard.integer(forKey: "selected_app_theme") == 1
        let finalTextColor = isDark ? UIColor.white : UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0)
        
        // 1. Форматируем список принимаемых вещей (shortDescription)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        
        let shortTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium),
            NSAttributedString.Key.foregroundColor: finalTextColor,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        
        shortDescriptionLabel.attributedText = NSAttributedString(string: data.shortDescription, attributes: shortTextAttributes)
        
        // 2. Рендерим графику
        if let image = UIImage(named: data.imageName) {
            imageView.image = image
        } else {
            imageView.image = UIImage(systemName: "arrow.3.trianglepath")
            imageView.tintColor = .appAccent
        }
        
        // 3. Динамически парсим fullDescription на красивые карточки правил сдачи
        rulesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                
                let paragraphs = data.fullDescription.components(separatedBy: "\n").filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
                
                for (index, text) in paragraphs.enumerated() {
                    let isWarning = index == 0 && (text.contains("отделить") || text.contains("Не сдавайте") || text.contains("исклечить") || text.contains("исключить"))
                    
                    // Просто создаем карточку. Вся магия цвета теперь зашита прямо внутри неё!
                    let ruleCard = createRuleInfoCard(text: text, isWarning: isWarning)
                    rulesStackView.addArrangedSubview(ruleCard)
                }
    }
    
    
    
    // MARK: - Настройка верстки (Auto Layout)
    private func setupLayout() {
        view.addSubview(scrollView)
        
        // ВАЖНО: mainCardView теперь добавляется внутрь scrollView,
        // а cardContentView — внутрь mainCardView!
        scrollView.addSubview(mainCardView)
        mainCardView.addSubview(cardContentView)
        
        cardContentView.addArrangedSubview(imageView)
        cardContentView.addArrangedSubview(shortDescriptionLabel)
        cardContentView.addArrangedSubview(rulesStackView)
        
        NSLayoutConstraint.activate([
            // 1. Скролл жестко привязываем к границам safeArea экрана
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor), // Привязка к верхнему краю нижнего бара
            
            // 2. Большая карточка ОПРЕДЕЛЯЕТ высоту скролла
            mainCardView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 8),
            mainCardView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            mainCardView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            // СВЕРХВАЖНАЯ СТРОКА: нижний край карточки привязываем к НИЖНЕМУ КРАЮ контента скролла
            mainCardView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            
            // Жестко фиксируем ширину карточки, чтобы она скроллилась только ВВЕРХ-ВНИЗ
            mainCardView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32),
            
            // 3. Внутренний стек растягивает саму карточку
            cardContentView.topAnchor.constraint(equalTo: mainCardView.topAnchor, constant: 24),
            cardContentView.leadingAnchor.constraint(equalTo: mainCardView.leadingAnchor, constant: 20),
            cardContentView.trailingAnchor.constraint(equalTo: mainCardView.trailingAnchor, constant: -20),
            // СВЕРХВАЖНАЯ СТРОКА: стек толкает нижнюю границу карточки вниз по мере добавления правил!
            cardContentView.bottomAnchor.constraint(equalTo: mainCardView.bottomAnchor, constant: -24),
            
            // Картинка внутри стека
            imageView.leadingAnchor.constraint(equalTo: cardContentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: cardContentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    
    // MARK: - Вспомогательный метод создания инфо-плашек
    private func createRuleInfoCard(text: String, isWarning: Bool) -> UIView {
        let container = UIView()
        
        // Метим карточку специальным номером
                container.tag = 999
        container.layer.cornerRadius = 16
        container.translatesAutoresizingMaskIntoConstraints = false
        
        // === МАГИЯ АВТО-ПЕРЕКЛЮЧЕНИЯ ЦВЕТА ФОНА ===
        // Создаем динамический цвет для фона, который САМ переключается системой iOS!
        container.backgroundColor = UIColor { traitCollection in
            // Проверяем, какая тема включена в UserDefaults прямо сейчас
            let isDark = UserDefaults.standard.integer(forKey: "selected_app_theme") == 1
            
            if isDark {
                // В тёмной теме: Warning — бордовый, обычный инфо — тёмно-серый
                return isWarning ? UIColor(red: 0.22, green: 0.14, blue: 0.14, alpha: 1.0) : .appCardBackground
            } else {
                // В светлой теме: Warning — нежно-розовый, обычный инфо — светло-серый #F5F5F5
                return isWarning ? UIColor(red: 1.0, green: 0.96, blue: 0.96, alpha: 1.0) : UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
            }
        }
        
        let icon = UIImageView(image: UIImage(systemName: isWarning ? "exclamationmark.triangle.fill" : "info.circle.fill"))
        icon.tintColor = isWarning ? .systemRed : .appAccent
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // === МАГИЯ АВТО-ПЕРЕКЛЮЧЕНИЯ ЦВЕТА ТЕКСТА ===
        // Создаем динамический цвет для текста внутри карточки
        label.textColor = UIColor { traitCollection in
            let isDark = UserDefaults.standard.integer(forKey: "selected_app_theme") == 1
            // В тёмной теме текст станет белым, в светлой теме — тёмным #1A1A1A
            return isDark ? UIColor.white : UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0)
        }
        
        container.addSubview(icon)
        container.addSubview(label)
        
        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: container.topAnchor, constant: 14),
            icon.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 14),
            icon.widthAnchor.constraint(equalToConstant: 20),
            icon.heightAnchor.constraint(equalToConstant: 20),
            
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -14),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])
        
        return container
    }

}
