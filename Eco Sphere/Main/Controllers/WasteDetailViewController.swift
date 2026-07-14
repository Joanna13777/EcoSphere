// экран-шаблон с описанием

import UIKit

class WasteDetailViewController: UIViewController {
    
    // Свойство для получения данных из PageViewController
    var wasteData: WasteType? {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - UI-Элементы
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // Короткое описание (теперь находится справа от картинки)
    private let shortDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Подробная инструкция (находится снизу под ними)
    private let fullDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Главный вертикальный контейнер
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // Верхняя строчка: Картинка слева + Короткое описание справа
    private let topHorizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .top // Выравниваем по верхнему краю, чтобы текст не прыгал вниз, если он короткий
        stack.distribution = .fill
        return stack
    }()
    
    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        updateUI()
    }
    
    // MARK: - Настройка верстки
    private func setupLayout() {
        // Собираем верхнюю секцию: картинка слева, короткое описание справа
        topHorizontalStackView.addArrangedSubview(imageView)
        topHorizontalStackView.addArrangedSubview(shortDescriptionLabel)
        
        // Собираем всё в единый вертикальный стек
        mainStackView.addArrangedSubview(topHorizontalStackView)
        mainStackView.addArrangedSubview(fullDescriptionLabel)
        
        view.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            // Ограничиваем размеры картинки (фиксированный квадрат 80х80)
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            
            // Привязываем главный контейнер к экрану с красивыми отступами
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Оставляем нижнюю границу свободной, чтобы текст разной длины не растягивался принудительно
            mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -24)
        ])
    }
    
    // MARK: - Наполнение данными
    private func updateUI() {
        guard isViewLoaded, let data = wasteData else { return }
        
        // Создаем отступ сверху специально для текста короткого описания
                // Меняйте значение ParagraphStyle.firstLineHeadIndent или используйте NSMutableAttributedString для идеального сдвига:
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4 // межстрочный интервал для буллетов
                
                let attributedString = NSMutableAttributedString(
                    string: data.shortDescription,
                    attributes: [
                        .font: UIFont.systemFont(ofSize: 15, weight: .medium),
                        .paragraphStyle: paragraphStyle
                           
                    ]
                )
        // Используем attributedText, чтобы применился lineSpacing
                shortDescriptionLabel.attributedText = attributedString
        
        
        // Разносим свойства по разным текстовым полям
        shortDescriptionLabel.text = data.shortDescription
        fullDescriptionLabel.text = data.fullDescription
        
        // Загружаем картинку
        if let image = UIImage(named: data.imageName) {
            imageView.image = image
        } else {
            imageView.image = UIImage(systemName: "trash.circle")
            imageView.tintColor = .systemGreen
        }
    }
}
