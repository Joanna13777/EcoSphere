import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    // Переменная замыкания для обработки нажатия на кнопку "далее"
    var onMoreButtonTapped: (() -> Void)?
    
    // MARK: - UI Элементы
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.right")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let expandableStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let previewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("далее", for: .normal)
        // Эко-зеленый цвет для кнопки из ТЗ
        button.setTitleColor(UIColor(red: 0.20, green: 0.65, blue: 0.35, alpha: 1.0), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
        return button
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Инициализация
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        selectionStyle = .none
        backgroundColor = .white
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(expandableStackView)
        contentView.addSubview(separatorView)
        
        expandableStackView.addArrangedSubview(previewLabel)
        expandableStackView.addArrangedSubview(moreButton)
        
        NSLayoutConstraint.activate([
            // Стрелочка справа
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrowImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26),
            arrowImageView.widthAnchor.constraint(equalToConstant: 14),
            arrowImageView.heightAnchor.constraint(equalToConstant: 14),
            
            // Заголовок статьи
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            
            // Скрытый контейнер (Превью + Кнопка далее)
            expandableStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            expandableStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            expandableStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            expandableStackView.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -16),
            
            // Тонкая линия разделения между статьями
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    // MARK: - Конфигурация данных
    func configure(with item: ArticleItem) {
        titleLabel.text = item.title
        previewLabel.text = item.previewText
        
        // Магия аккордеона: показываем или скрываем блок с кнопкой в зависимости от флага
        expandableStackView.isHidden = !item.isExpanded
        
        if item.isExpanded {
            // Если статья раскрыта — красим заголовок в зеленый и переворачиваем стрелочку вниз
            titleLabel.textColor = UIColor(red: 0.20, green: 0.65, blue: 0.35, alpha: 1.0)
            arrowImageView.image = UIImage(systemName: "chevron.down")
        } else {
            // Если закрыта — возвращаем дефолтный строгий черный цвет и стрелку вправо
            titleLabel.textColor = .black
            arrowImageView.image = UIImage(systemName: "chevron.right")
        }
    }
    
    @objc private func moreTapped() {
        onMoreButtonTapped?()
    }
}
