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

