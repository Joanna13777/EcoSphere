import UIKit

class SortingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    // 1. Программные элементы интерфейса
    private let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Что вы хотите выбросить?"
        search.backgroundImage = UIImage()
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // База данных предметов
    private var allItems: [TrashItem] = []
    private var filteredItems: [TrashItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Сортировка"
        
        setupDelegates()
        setupLayout()
        setupMockData()
    }
    
    private func setupDelegates() {
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        // Регистрируем стандартную ячейку со встроенными стилями текста (Subtitle)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TrashCell")
    }
    
    private func setupLayout() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            // Поиск строго под верхним Navigation Bar
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // Таблица занимает всё оставшееся пространство до самого низа
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupMockData() {
        allItems = [
            TrashItem(name: "Офисная бумага, тетради", category: "Макулатура", comment: "Сдавать чистой, удалить скрепки", isRecyclable: true),
            TrashItem(name: "Пластиковая бутылка (ПЭТ 1)", category: "Пластик", comment: "Сполоснуть и обязательно смять", isRecyclable: true),
            TrashItem(name: "Стеклянная банка", category: "Стекло", comment: "Снять крышку, этикетку можно оставить", isRecyclable: true),
            TrashItem(name: "Чеки из магазинов", category: "Не перерабатывается", comment: "Это термобумага, содержит токсичный Бисфенол-А", isRecyclable: false),
            TrashItem(name: "Батарейки и аккумуляторы", category: "Опасные отходы", comment: "Сдавать только в специальные боксы в магазинах", isRecyclable: false),
            TrashItem(name: "Алюминиевая банка", category: "Металл", comment: "Сполоснуть от остатков напитка", isRecyclable: true),
            TrashItem(name: "Одноразовые бумажные стаканчики", category: "Не перерабатывается", comment: "Внутри покрыты тонким слоем пластиковой пленки", isRecyclable: false),
            TrashItem(name: "Картонные коробки", category: "Макулатура", comment: "Разрезать, сложить плоско и перевязать", isRecyclable: true)
        ]
        filteredItems = allItems
        tableView.reloadData()
    }
    
    // MARK: - UISearchBarDelegate (Логика поиска)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredItems = allItems
        } else {
            filteredItems = allItems.filter { $0.name.localizedCaseInsensitiveContains(searchText) || $0.category.localizedCaseInsensitiveContains(searchText) }
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Достаем ячейку и используем современную конфигурацию контента iOS 14+
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrashCell", for: indexPath)
        let item = filteredItems[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = item.name
        content.secondaryText = "\(item.category) • \(item.comment)"
        
        // Меняем цвета текста в зависимости от того, перерабатывается предмет или нет
        content.textProperties.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        content.secondaryTextProperties.color = UIColor.secondaryLabel 


        content.secondaryTextProperties.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        cell.contentConfiguration = content
        
        // Маленький цветной индикатор справа (зеленый чекбокс или красный крестик)
        let iconName = item.isRecyclable ? "checkmark.seal.fill" : "xmark.seal.fill"
        let iconView = UIImageView(image: UIImage(systemName: iconName))
        iconView.tintColor = item.isRecyclable ? .systemGreen : .systemRed
        cell.accessoryView = iconView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64 // Комфортная высота для двухстрочной ячейки
    }
}

// MARK: - Системное превью для Canvas
#Preview {
    let vc = SortingViewController()
    return UINavigationController(rootViewController: vc)
}
