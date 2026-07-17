import UIKit

// экран Сортировки в стиле Eco-Minimalism
class SortingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    // MARK: - Палитра цветов
    private let appBgColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)       // #F5F5F5
    private let darkTextColor = UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0)    // #1A1A1A
    private let secondaryTextColor = UIColor(red: 0.49, green: 0.49, blue: 0.49, alpha: 1.0) // #7E7E7E
    private let accentYellowColor = UIColor(red: 0.96, green: 0.71, blue: 0.10, alpha: 1.0)   // #F4B41A

    // MARK: - UI-Элементы
    private lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Что вы хотите выбросить?"
        search.backgroundImage = UIImage() // Убираем стандартную серую обводку
        search.backgroundColor = .clear
        
        // Кастомизируем внутреннее текстовое поле поиска под стиль Modern Clean
        if let textField = search.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white
            textField.font = .systemFont(ofSize: 15, weight: .medium)
            textField.textColor = darkTextColor
            textField.layer.cornerRadius = 16 // Мягкое скругление
            textField.layer.masksToBounds = true
            
            textField.layer.shadowColor = UIColor.black.cgColor
            textField.layer.shadowOpacity = 0.02
            textField.layer.shadowOffset = CGSize(width: 0, height: 4)
            textField.layer.shadowRadius = 8
            
            if let leftView = textField.leftView as? UIImageView {
                leftView.tintColor = accentYellowColor
            }
        }
        
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.separatorStyle = .none // Полностью убираем старые системные разделители линий
        table.showsVerticalScrollIndicator = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // База данных предметов
    private var allItems: [TrashItem] = []
    private var filteredItems: [TrashItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = appBgColor // Меняем стандартный фон на пастельный эко-оттенок
        title = "Сортировка"
        
        setupDelegates()
        setupLayout()
        setupMockData()
    }
    
    private func setupDelegates() {
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        // Регистрируем вынесенную кастомную ячейку
        tableView.register(CustomTrashCell.self, forCellReuseIdentifier: "TrashCell")
    }
    
    private func setupLayout() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            // Поиск строго под верхним Navigation Bar с красивыми отступами по бокам
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            // Таблица занимает всё оставшееся пространство до самого низа
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 12),
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrashCell", for: indexPath) as! CustomTrashCell
        let item = filteredItems[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension // Автоматический расчет высоты ячейки
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}

// MARK: - Системное превью для Canvas
#Preview {
    let vc = SortingViewController()
    return UINavigationController(rootViewController: vc)
}
