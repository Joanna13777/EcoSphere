import UIKit

// MARK: - Класс Ячейки Фильтров (Чипсы) в стиле Eco-Minimalism
class FilterCell: UICollectionViewCell {
    static let reuseIdentifier = "FilterCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Округлая форма капсулы-чипса по гайдлайнам Apple
        layer.cornerRadius = bounds.height / 2
        layer.masksToBounds = true
    }
    
    // Динамический расчет ширины ячейки для автоматического расширения при длинных словах
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: layoutAttributes.frame.height)
        let newAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        let size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        newAttributes.frame.size.width = ceil(size.width)
        return newAttributes
    }
    
    // MARK: - Конфигурация данных и стилей
    func configure(text: String, isSelected: Bool) {
        titleLabel.text = text
        
        if isSelected {
            // Стиль для выбранной категории: Желтый фон для активного таба, серый текст для неактивного
            backgroundColor = UIColor(red: 0.96, green: 0.71, blue: 0.10, alpha: 1.0) // #F4B41A
                    titleLabel.textColor = UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0)    // #1A1A1A
                    titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        } else {
            // Стиль для неактивной категории: Чистая белая карточка на пастельной подложке
            backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0) // #ECECEC (Чистый светлый серый)
                   titleLabel.textColor = UIColor(red: 0.35, green: 0.35, blue: 0.35, alpha: 1.0)    // #595959
                   titleLabel.font = .systemFont(ofSize: 14, weight: .medium)
        }
    }
}
