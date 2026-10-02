
import UIKit

class CustomDropDownCell: UITableViewCell {
    
    let markerImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .appText // Заменили .label на адаптивный текст
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .appSecondaryText // Заменили .secondaryLabel на адаптивный текст
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        backgroundColor = .clear // Прозрачный фон ячейки
        
        contentView.addSubview(markerImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        // Красивое выделение ячейки при тапе цветом разделителя
        let selectedBgView = UIView()
        selectedBgView.backgroundColor = .appSeparator
        selectedBackgroundView = selectedBgView
        
        NSLayoutConstraint.activate([
            markerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            markerImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            markerImageView.widthAnchor.constraint(equalToConstant: 24),
            markerImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: markerImageView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 22),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with item: DropDownItem) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        markerImageView.image = UIImage(systemName: item.iconName)
        markerImageView.tintColor = item.iconColor
    }
}


