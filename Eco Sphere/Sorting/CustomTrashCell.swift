// отвечает исключительно за отрисовку скругленной карточки элемента списка.

import UIKit

// MARK: - Кастомная Ячейка-Карточка (CustomTrashCell)
class CustomTrashCell: UITableViewCell {
    
    // Белая карточка-подложка для эффекта парения
    private let cardBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20 // Большое закругление по ТЗ
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.02
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0) // #1A1A1A
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 0.49, green: 0.49, blue: 0.49, alpha: 1.0) // #7E7E7E
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(cardBackgroundView)
        cardBackgroundView.addSubview(titleLabel)
        cardBackgroundView.addSubview(subTitleLabel)
        cardBackgroundView.addSubview(statusIconImageView)
        
        NSLayoutConstraint.activate([
            // Привязываем белую карточку с отступами 6px (верх/низ) и 16px (бока), формируя зазоры между ячейками
            cardBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            // Статусная иконка справа
            statusIconImageView.trailingAnchor.constraint(equalTo: cardBackgroundView.trailingAnchor, constant: -16),
            statusIconImageView.centerYAnchor.constraint(equalTo: cardBackgroundView.centerYAnchor),
            statusIconImageView.widthAnchor.constraint(equalToConstant: 26),
            statusIconImageView.heightAnchor.constraint(equalToConstant: 26),
            
            // Название предмета внутри карточки
            titleLabel.topAnchor.constraint(equalTo: cardBackgroundView.topAnchor, constant: 14),
            titleLabel.leadingAnchor.constraint(equalTo: cardBackgroundView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: statusIconImageView.leadingAnchor, constant: -12),
            
            // Комментарий и категория снизу под названием
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subTitleLabel.leadingAnchor.constraint(equalTo: cardBackgroundView.leadingAnchor, constant: 16),
            subTitleLabel.trailingAnchor.constraint(equalTo: statusIconImageView.leadingAnchor, constant: -12),
            subTitleLabel.bottomAnchor.constraint(equalTo: cardBackgroundView.bottomAnchor, constant: -14)
        ])
    }
    
    func configure(with item: TrashItem) {
        titleLabel.text = item.name
        
        // Красиво стилизуем вторую строчку: выделяем Категорию цветом
        let categoryColor = item.isRecyclable ? "🟢 \(item.category)" : "🔴 \(item.category)"
        subTitleLabel.text = "\(categoryColor)  •  \(item.comment)"
        
        // Меняем иконку и её цвет в зависимости от возможности переработки
        let iconName = item.isRecyclable ? "checkmark.seal.fill" : "xmark.seal.fill"
        statusIconImageView.image = UIImage(systemName: iconName)
        statusIconImageView.tintColor = item.isRecyclable ? UIColor(red: 0.96, green: 0.71, blue: 0.10, alpha: 1.0) : .systemRed
        
        // Фон карточки: для перерабатываемых — белый, для неперерабатываемых — нейтрально-серый (без зеленого оттенка)
        cardBackgroundView.backgroundColor = item.isRecyclable ? .white : UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
    }
}
