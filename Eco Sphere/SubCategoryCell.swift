import UIKit

class SubCategoryCell: UICollectionViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1 // Строго в одну линию
            label.adjustsFontSizeToFitWidth = false // Запрещаем уменьшать размер шрифта
            
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
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
        // Задаем большое скругление для эффекта "чипсов"
        layer.cornerRadius = 14
        clipsToBounds = true
        
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            // Важно задавать внутренние отступы (padding) для contentView, чтобы система знала, как рассчитать ширину ячейки
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18)
        ])
    }
    
    
    
    func configure(with title: String, isSelected: Bool) {
        titleLabel.text = title
        
        // Цвета в стиле референса: сочный зеленый для активного, полупрозрачный белый на сером фоне для пассивного
        if isSelected {
            backgroundColor = UIColor(red: 0.96, green: 0.71, blue: 0.10, alpha: 1.0) // #F4B41A (Выбранный таб залит желтым)
            titleLabel.textColor = .darkText
            titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        } else {
            backgroundColor = .white.withAlphaComponent(0.6)
            titleLabel.textColor = UIColor(red: 0.49, green: 0.49, blue: 0.49, alpha: 1.0) // #7E7E7E (Невыбранный — серый)
            titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        }
    }
}

#Preview {
    let cell = SubCategoryCell(frame: CGRect(x: 0, y: 0, width: 120, height: 44))
    cell.configure(with: "Макулатура", isSelected: true)
    return cell
}
