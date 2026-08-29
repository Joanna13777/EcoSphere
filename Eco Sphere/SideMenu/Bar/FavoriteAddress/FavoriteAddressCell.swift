import UIKit

class FavoriteAddressCell: UITableViewCell {
    
    // MARK: - UI Elements
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .appCardBackground // Наш адаптивный фон для карточек
        view.layer.cornerRadius = 14
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.appSeparator.cgColor // Адаптивная рамка
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "mappin.circle.fill")
        iv.tintColor = .appAccent // Наш фирменный желтый акцент
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .appText // Адаптивный текст
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .appSecondaryText // Адаптивный серый текст
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        setupLayout()
        setupThemeObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupHierarchy() {
        backgroundColor = .clear
        selectionStyle = .none // Отключаем стандартное серое выделение всей ячейки
        
        contentView.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(addressLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            // Отступы для карточки внутри ячейки
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            // Иконка слева
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 32),
            iconImageView.heightAnchor.constraint(equalToConstant: 32),
            
            // Название (Дом / Работа)
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // Сам адрес под названием
            addressLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            addressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            addressLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            addressLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -14)
        ])
    }
    
    // MARK: - Public Configure Method
    func configure(title: String, address: String, iconName: String = "mappin.circle.fill") {
        titleLabel.text = title
        addressLabel.text = address
        iconImageView.image = UIImage(systemName: iconName)
    }
    
    // MARK: - Theme Observer (iOS 17+)
    // MARK: - Theme Observer (iOS 17+)
    private func setupThemeObserver() {
        if #available(iOS 17.0, *) {
            // Убрали [weak self], так как работаем напрямую через переменную cell
            registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (cell: FavoriteAddressCell, _) in
                cell.containerView.layer.borderColor = UIColor.appSeparator.cgColor
            }
        }
    }

    
    @available(iOS, deprecated: 17.0, message: "Use registerForTraitChanges instead")
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 17.0, *) { return }
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            containerView.layer.borderColor = UIColor.appSeparator.cgColor
        }
    }
}
