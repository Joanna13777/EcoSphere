import UIKit

// MARK: - Класс Ячейки с выравниванием текста строго по центру
class FilterCell: UICollectionViewCell {
    static let reuseIdentifier = "FilterCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        layer.masksToBounds = true
    }
    
    // MARK: - Конфигурация данных и стилей
    func configure(text: String, isSelected: Bool) {
        titleLabel.text = text
        
        if isSelected {
            // Стиль для выбранной (активной) категории
            backgroundColor = .systemGreen
            titleLabel.textColor = .white
        } else {
            // Стиль для неактивной категории
            backgroundColor = UIColor(white: 0.95, alpha: 1.0)
            titleLabel.textColor = .darkGray
        }
    }
}
