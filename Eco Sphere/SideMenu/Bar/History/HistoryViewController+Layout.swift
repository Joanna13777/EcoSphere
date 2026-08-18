import UIKit

// MARK: - Верстка интерфейса (Auto Layout)
extension HistoryViewController {
    
    func setupLayout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - КАСТОМНАЯ КАРТОЧКА ЗАКАЗА ИСТОРИИ
class HistoryOrderCell: UITableViewCell {
    
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.98, alpha: 1.0)
        view.layer.cornerRadius = 14
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
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let weightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        selectionStyle = .none
        setupCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCellLayout() {
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
    
    func configure(with order: HistoryOrder) {
        wasteTypeLabel.text = order.wasteType
        dateLabel.text = order.date
        addressLabel.text = order.address
        weightLabel.text = order.weight
        
        iconImageView.image = UIImage(systemName: order.iconName)
        iconImageView.tintColor = order.iconColor
        statusLabel.text = order.status
        
        if order.isCompleted {
            statusContainer.backgroundColor = UIColor(red: 0.90, green: 0.96, blue: 0.90, alpha: 1.0)
            statusLabel.textColor = UIColor(red: 0.15, green: 0.45, blue: 0.15, alpha: 1.0)
        } else {
            statusContainer.backgroundColor = UIColor(red: 0.99, green: 0.95, blue: 0.85, alpha: 1.0)
            statusLabel.textColor = UIColor(red: 0.70, green: 0.45, blue: 0.05, alpha: 1.0)
        }
    }
}
