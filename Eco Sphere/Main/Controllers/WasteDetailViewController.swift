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
    private let appBgColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0) // #F5F5F5
    private let darkTextColor = UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0) // #1A1A1A
    private let secondaryTextColor = UIColor(red: 0.49, green: 0.49, blue: 0.49, alpha: 1.0) // #7E7E7E
    private let accentYellowColor = UIColor(red: 0.96, green: 0.71, blue: 0.10, alpha: 1.0) // #F4B41A (Яркий желтый)
     
     // MARK: - UI-Элементы
     
     // 1. Главная белая карточка-подложка для контента
     private let mainCardView: UIView = {
         let view = UIView()
         view.backgroundColor = .white
         view.layer.cornerRadius = 28
         view.layer.shadowColor = UIColor.black.cgColor
         view.layer.shadowOpacity = 0.03
         view.layer.shadowOffset = CGSize(width: 0, height: 6)
         view.layer.shadowRadius = 16
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
         view.backgroundColor = appBgColor // Меняем стандартный фон на пастельный
         setupLayout()
         updateUI()
     }
    
    // MARK: - Настройка верстки
        private func setupLayout() {
            view.addSubview(scrollView)
            scrollView.addSubview(mainCardView)
            mainCardView.addSubview(cardContentView)
            
            // Наполняем контентный стек внутри белой карточки
            cardContentView.addArrangedSubview(imageView)
            cardContentView.addArrangedSubview(shortDescriptionLabel)
            cardContentView.addArrangedSubview(rulesStackView)
            
            NSLayoutConstraint.activate([
                // Скролл по всему экрану
                scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
                // Большая белая карточка внутри скролла
                mainCardView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8),
                mainCardView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
                mainCardView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
                mainCardView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -24),
                mainCardView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
                
                // Внутренние отступы контента внутри карточки
                cardContentView.topAnchor.constraint(equalTo: mainCardView.topAnchor, constant: 24),
                cardContentView.leadingAnchor.constraint(equalTo: mainCardView.leadingAnchor, constant: 20),
                cardContentView.trailingAnchor.constraint(equalTo: mainCardView.trailingAnchor, constant: -20),
                cardContentView.bottomAnchor.constraint(equalTo: mainCardView.bottomAnchor, constant: -24),
                
                // Принудительно растягиваем картинку по ширине контейнера
                imageView.leadingAnchor.constraint(equalTo: cardContentView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: cardContentView.trailingAnchor),
                
                // Задаем комфортную пропорциональную высоту для горизонтального баннера (например, 160 поинтов)
                        imageView.heightAnchor.constraint(equalToConstant: 180)
            ])
        }
        
        // MARK: - Наполнение данными
        private func updateUI() {
            guard isViewLoaded, let data = wasteData else { return }
            
            // 1. Форматируем список принимаемых вещей (shortDescription)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6
            
            let shortTextAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 16, weight: .medium),
                .foregroundColor: darkTextColor,
                .paragraphStyle: paragraphStyle
            ]
            
            shortDescriptionLabel.attributedText = NSAttributedString(string: data.shortDescription, attributes: shortTextAttributes)
            
            // 2. Рендерим современную графику
            if let image = UIImage(named: data.imageName) {
                imageView.image = image
            } else {
                imageView.image = UIImage(systemName: "arrow.3.trianglepath") // Минималистичная петля Мёбиуса по дефолту
                imageView.tintColor = accentYellowColor
            }
            
            // 3. Динамически парсим fullDescription на красивые карточки правил сдачи
            // Очищаем старые правила, если они были добавлены
            rulesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            
            // Разделяем сплошной текст по точкам или абзацам (смотря как данные забиты в модели)
            let paragraphs = data.fullDescription.components(separatedBy: "\n").filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            
            for (index, text) in paragraphs.enumerated() {
                // Первое правило в макулатуре — обычно предупреждение про металл/пластик (делаем его Warning)
                let isWarning = index == 0 && (text.contains("отделить") || text.contains("Не сдавайте") || text.contains("исключить"))
                let ruleCard = createRuleInfoCard(text: text, isWarning: isWarning)
                rulesStackView.addArrangedSubview(ruleCard)
            }
        }
        
        // MARK: - Вспомогательный метод создания инфо-плашек
        private func createRuleInfoCard(text: String, isWarning: Bool) -> UIView {
            let container = UIView()
            container.backgroundColor = isWarning ? UIColor(red: 1.0, green: 0.96, blue: 0.96, alpha: 1.0) : appBgColor
            container.layer.cornerRadius = 16
            container.translatesAutoresizingMaskIntoConstraints = false
            
            let icon = UIImageView(image: UIImage(systemName: isWarning ? "exclamationmark.triangle.fill" : "info.circle.fill"))
            icon.tintColor = isWarning ? .systemRed : accentYellowColor
            icon.contentMode = .scaleAspectFit
            icon.translatesAutoresizingMaskIntoConstraints = false
            
            let label = UILabel()
            label.text = text
            label.font = .systemFont(ofSize: 14, weight: .regular)
            label.textColor = darkTextColor
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            
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
