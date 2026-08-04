import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    // MARK: - UI Элементы
    private let cardBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.02
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(red: 0.49, green: 0.49, blue: 0.49, alpha: 1.0)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.right")
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemGray3
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // Констрейнты для управления динамической высотой текстовой карточки
    private var textBottomToCardConstraint: NSLayoutConstraint!
    private var subtitleBottomToCardConstraint: NSLayoutConstraint!

    // MARK: - Инициализация
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(cardBackgroundView)
        cardBackgroundView.addSubview(titleLabel)
        cardBackgroundView.addSubview(subtitleLabel)
        cardBackgroundView.addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            cardBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            arrowImageView.trailingAnchor.constraint(equalTo: cardBackgroundView.trailingAnchor, constant: -16),
            arrowImageView.topAnchor.constraint(equalTo: cardBackgroundView.topAnchor, constant: 22),
            arrowImageView.widthAnchor.constraint(equalToConstant: 14),
            arrowImageView.heightAnchor.constraint(equalToConstant: 14),
            
            titleLabel.topAnchor.constraint(equalTo: cardBackgroundView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: cardBackgroundView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -12),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: cardBackgroundView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: cardBackgroundView.trailingAnchor, constant: -20)
        ])
        
        // Создаем жесткие нижние привязки к границам карточки
        textBottomToCardConstraint = titleLabel.bottomAnchor.constraint(equalTo: cardBackgroundView.bottomAnchor, constant: -20)
        subtitleBottomToCardConstraint = subtitleLabel.bottomAnchor.constraint(equalTo: cardBackgroundView.bottomAnchor, constant: -20)
    }
    
    // MARK: - Конфигурация данных
    func configure(with item: ArticleItem) {
        titleLabel.text = item.title
        
        // Переключаем констрейнты в зависимости от наличия подзаголовка на карточке
        if let subtitle = item.subtitleText, !subtitle.isEmpty {
            subtitleLabel.text = subtitle
            subtitleLabel.isHidden = false
            
            textBottomToCardConstraint.isActive = false
            subtitleBottomToCardConstraint.isActive = true
        } else {
            subtitleLabel.text = ""
            subtitleLabel.isHidden = true
            
            subtitleBottomToCardConstraint.isActive = false
            textBottomToCardConstraint.isActive = true
        }
    }
}
