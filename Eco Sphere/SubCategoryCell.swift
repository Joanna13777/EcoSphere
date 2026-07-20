//  Кнопка-чипс с иконкой и текстом в стиле Eco-Minimalism

import UIKit

class SubCategoryCell: UICollectionViewCell {
    
    // Иконка категории (используем системные SF Symbols для надежности)
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Горизонтальный контейнер для иконки и текста
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8 // Отступ между иконкой и текстом
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        layer.cornerRadius = 14
        clipsToBounds = true
        
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(iconImageView)
        contentStackView.addArrangedSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            // Привязываем стек к границам контента с красивыми внутренними отступами
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Задаем фиксированный квадратный размер для иконки внутри кнопки
            iconImageView.widthAnchor.constraint(equalToConstant: 18),
            iconImageView.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    // Конфигурация ячейки: принимает текст, имя системной иконки и статус выбора
    func configure(with title: String, iconName: String, isSelected: Bool) {
        titleLabel.text = title
        iconImageView.image = UIImage(systemName: iconName)
        
        if isSelected {
            // Выбранное состояние: Желтая плашка, черный графитовый текст и иконка
            backgroundColor = UIColor(red: 0.96, green: 0.71, blue: 0.10, alpha: 1.0) // #F4B41A
            titleLabel.textColor = UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0)
            iconImageView.tintColor = UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0)
            titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        } else {
            // Неактивное состояние: Светло-серая плашка, серый текст и иконка
            backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0) // #ECECEC
            titleLabel.textColor = UIColor(red: 0.49, green: 0.49, blue: 0.49, alpha: 1.0)
            iconImageView.tintColor = UIColor(red: 0.49, green: 0.49, blue: 0.49, alpha: 1.0)
            titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        }
    }
}


//#Preview {
//    let cell = SubCategoryCell(frame: CGRect(x: 0, y: 0, width: 120, height: 44))
//    cell.configure(with: "Бумага", isSelected: true)
//    return cell
//}
