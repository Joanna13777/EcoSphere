import UIKit

// Структура данных для элементов выпадающего списка
struct DropDownItem {
    let title: String
    let subtitle: String
    let iconName: String
    let iconColor: UIColor
}

class SortingDropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    // Блок замыкания (closure) для передачи выбранных данных обратно в контроллер
    var onItemSelected: ((DropDownItem) -> Void)?
    
    private var allItems: [DropDownItem] = []
    
    // MARK: - UI Элементы (Свойство объявлено открытым внутри класса, чтобы убрать ошибку)
    let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.backgroundColor = .white
        tv.separatorStyle = .singleLine
        tv.separatorColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.0)
        
        // СРАЗУ ОТКЛЮЧАЕМ СКРОЛЛ ТУТ: Все 6 элементов поместятся без прокрутки
        tv.isScrollEnabled = false
        
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // MARK: - Init
    init(items: [DropDownItem]) {
        super.init(frame: .zero)
        self.allItems = items
        
        backgroundColor = .white
        layer.cornerRadius = 14
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.12
        layer.shadowOffset = CGSize(width: 0, height: 6)
        layer.shadowRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1.0).cgColor
        clipsToBounds = true // Округляет края таблицы вместе с рамкой
        
        setupLayout()
        setupComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        tableView.tableFooterView = UIView() // Убирает пустые линии внизу таблицы
    }
    
    // MARK: - UITableView Data Source & Delegate
    func tableView(_ tableView: UITableView, numberOfItemsInSection section: Int) -> Int {
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Используем строго стандартный системный вызов dequeue с аргументом 'for:'
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropCell", for: indexPath) as! CustomDropDownCell
        let item = allItems[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64 // Высота строк под две строчки текста
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem = allItems[indexPath.row]
        onItemSelected?(selectedItem)
    }
}

// MARK: - КАСТОМНАЯ ЯЧЕЙКА ДРОПДАУНА (Маркер + Заголовок + Подзаголовок)
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
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemGray
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
        contentView.addSubview(markerImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
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
