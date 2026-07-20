import UIKit

class CustomTrashCell: UITableViewCell {
    
    // Белая карточка-подложка для эффекта парения
    private let cardBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
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
        label.textColor = UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 0.49, green: 0.49, blue: 0.49, alpha: 1.0)
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
            cardBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            statusIconImageView.trailingAnchor.constraint(equalTo: cardBackgroundView.trailingAnchor, constant: -16),
            statusIconImageView.centerYAnchor.constraint(equalTo: cardBackgroundView.centerYAnchor),
            statusIconImageView.widthAnchor.constraint(equalToConstant: 26),
            statusIconImageView.heightAnchor.constraint(equalToConstant: 26),
            
            titleLabel.topAnchor.constraint(equalTo: cardBackgroundView.topAnchor, constant: 14),
            titleLabel.leadingAnchor.constraint(equalTo: cardBackgroundView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: statusIconImageView.leadingAnchor, constant: -12),
            
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subTitleLabel.leadingAnchor.constraint(equalTo: cardBackgroundView.leadingAnchor, constant: 16),
            subTitleLabel.trailingAnchor.constraint(equalTo: statusIconImageView.leadingAnchor, constant: -12),
            subTitleLabel.bottomAnchor.constraint(equalTo: cardBackgroundView.bottomAnchor, constant: -14)
        ])
    }
    
    func configure(with item: TrashItem) {
        titleLabel.text = item.name
        
        let categoryColor = item.isRecyclable ? "🟢 \(item.category)" : "🔴 \(item.category)"
        subTitleLabel.text = "\(categoryColor)  •  \(item.comment)"
        
        let iconName = item.isRecyclable ? "checkmark.seal.fill" : "xmark.seal.fill"
        statusIconImageView.image = UIImage(systemName: iconName)
        statusIconImageView.tintColor = item.isRecyclable ? UIColor(red: 0.96, green: 0.71, blue: 0.10, alpha: 1.0) : .systemRed
        
        cardBackgroundView.backgroundColor = item.isRecyclable ? .white : UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
    }
}
