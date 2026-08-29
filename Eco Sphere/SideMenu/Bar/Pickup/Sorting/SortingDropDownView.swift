import UIKit

class SortingDropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var onItemSelected: ((DropDownItem) -> Void)?
    private var allItems: [DropDownItem] = []
    
    let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.backgroundColor = .clear // Делаем прозрачной, так как фон задан у самого UIView
        tv.separatorStyle = .singleLine
        tv.separatorColor = .appSeparator // Заменили хардкод на адаптивный разделитель
        tv.isScrollEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // MARK: - Инициализатор
    init(items: [DropDownItem]) {
        super.init(frame: .zero)
        self.allItems = items
        
        // Используем глобальные адаптивные цвета
        backgroundColor = .appCardBackground // Меняется автоматически (светло-серый / темно-серый)
        layer.cornerRadius = 14
        
        // Настройка тени
        updateShadowColor()
        layer.shadowOpacity = 0.12
        layer.shadowOffset = CGSize(width: 0, height: 6)
        layer.shadowRadius = 12
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.appSeparator.cgColor
        
        clipsToBounds = false // Чтобы тень не обрезалась снаружи
        tableView.clipsToBounds = true // А таблицу внутри обрезаем по скругленным углам
        
        setupLayout()
        setupComponents()
        setupThemeObserver() // Запуск современного API для iOS 17+
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Современное отслеживание темы (iOS 17+) с поддержкой старых версий
    private func setupThemeObserver() {
        if #available(iOS 17.0, *) {
            registerForTraitChanges([UITraitUserInterfaceStyle.self]) { [weak self] (dropdown: SortingDropDownView, previousTraitCollection) in
                self?.layer.borderColor = UIColor.appSeparator.cgColor
                self?.updateShadowColor()
            }
        }
    }

    
    // Поддержка устройств на iOS 16 и ниже (iOS 17 проигнорирует этот метод)
    @available(iOS, deprecated: 17.0, message: "Use registerForTraitChanges instead")
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 17.0, *) { return }
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            layer.borderColor = UIColor.appSeparator.cgColor
            updateShadowColor()
        }
    }

    
    // Коррекция цвета тени (в темной теме тени скрываем, чтобы не создавать грязь)
    private func updateShadowColor() {
        if traitCollection.userInterfaceStyle == .dark {
            layer.shadowColor = UIColor.clear.cgColor
        } else {
            layer.shadowColor = UIColor.black.cgColor
        }
    }
    
    private func setupLayout() {
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupComponents() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomDropDownCell.self, forCellReuseIdentifier: "DropCell")
        tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropCell", for: indexPath) as! CustomDropDownCell
        let item = allItems[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = allItems[indexPath.row]
        onItemSelected?(selectedItem)
    }
}

// MARK: - CustomDropDownCell
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
