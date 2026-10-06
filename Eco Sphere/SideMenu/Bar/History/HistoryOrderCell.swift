import UIKit

// MARK: - КАСТОМНАЯ КАРТОЧКА ЗАКАЗА ИСТОРИИ
class HistoryOrderCell: UITableViewCell {
    
    let cardView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.backgroundColor = .appCardBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let wasteTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let weightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .label
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let statusContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Инициализатор
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupLayout() // Исправлено: имя вызываемого метода приведено в соответствие
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Констраинты и Верстка
    private func setupLayout() {
        contentView.addSubview(cardView)
        cardView.addSubview(iconImageView)
        cardView.addSubview(wasteTypeLabel)
        cardView.addSubview(dateLabel)
        cardView.addSubview(addressLabel)
        cardView.addSubview(weightLabel)
        
        statusContainer.addSubview(statusLabel)
        cardView.addSubview(statusContainer)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            iconImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            iconImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            wasteTypeLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            wasteTypeLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            wasteTypeLabel.trailingAnchor.constraint(equalTo: weightLabel.leadingAnchor, constant: -8),
            
            weightLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            weightLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            weightLabel.widthAnchor.constraint(equalToConstant: 70),
            
            dateLabel.leadingAnchor.constraint(equalTo: wasteTypeLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: wasteTypeLabel.bottomAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: statusContainer.leadingAnchor, constant: -8),
            
            addressLabel.leadingAnchor.constraint(equalTo: wasteTypeLabel.leadingAnchor),
            addressLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
            addressLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            statusContainer.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            statusContainer.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: 6),
            statusContainer.heightAnchor.constraint(equalToConstant: 22),
            statusContainer.widthAnchor.constraint(equalToConstant: 90),
            
            statusLabel.centerXAnchor.constraint(equalTo: statusContainer.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: statusContainer.centerYAnchor)
        ])
    }
    
    // MARK: - Конфигурация данными
    func configure(with order: HistoryOrder) {
        wasteTypeLabel.text = order.wasteType
        dateLabel.text = order.date
        addressLabel.text = order.address
        weightLabel.text = order.weight
        
        // Устанавливаем системное имя картинки отхода
        iconImageView.image = UIImage(systemName: order.iconName)
        
        // Динамически красим саму иконку в цвет отхода из модели
        let isDark = UserDefaults.standard.integer(forKey: "selected_app_theme") == 1
        let baseIconColor = order.iconColor
        
        // Если цвет серый и включена темная тема — подсветим белым, чтобы иконка не сливалась с темным фоном
        iconImageView.tintColor = (baseIconColor == .systemGray && isDark) ? .white : baseIconColor
        
        // Полностью очищаем фоновый цвет и отключаем обрезку по углам
        iconImageView.backgroundColor = .clear
        iconImageView.layer.cornerRadius = 0
        iconImageView.clipsToBounds = false
        
        statusLabel.text = order.status
        cardView.backgroundColor = .appCardBackground
        
        // Тонкая настройка цветных плашек статуса (Выполнено / Отменен / В обработке)
        if order.status == "Отменен" {
            if isDark {
                statusContainer.backgroundColor = UIColor.systemRed.withAlphaComponent(0.2)
                statusLabel.textColor = UIColor.systemRed
            } else {
                statusContainer.backgroundColor = UIColor(red: 0.99, green: 0.90, blue: 0.90, alpha: 1.0)
                statusLabel.textColor = UIColor(red: 0.75, green: 0.15, blue: 0.15, alpha: 1.0)
            }
        } else if order.status == "Выполнено" || order.isCompleted {
            if isDark {
                statusContainer.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
                statusLabel.textColor = UIColor.systemGreen
            } else {
                statusContainer.backgroundColor = UIColor(red: 0.90, green: 0.96, blue: 0.90, alpha: 1.0)
                statusLabel.textColor = UIColor(red: 0.15, green: 0.45, blue: 0.15, alpha: 1.0)
            }
        } else {
            if isDark {
                statusContainer.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.2)
                statusLabel.textColor = UIColor.systemOrange
            } else {
                statusContainer.backgroundColor = UIColor(red: 0.99, green: 0.95, blue: 0.85, alpha: 1.0)
                statusLabel.textColor = UIColor(red: 0.70, green: 0.45, blue: 0.05, alpha: 1.0)
            }
        }
    }


}
