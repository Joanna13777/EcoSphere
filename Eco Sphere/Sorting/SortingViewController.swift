import UIKit

// Экран Сортировки в стиле Eco-Minimalism
class SortingViewController: UIViewController {

    // MARK: - Палитра цветов
    let appBgColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)       // #F5F5F5
    let darkTextColor = UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0)    // #1A1A1A
    private let accentYellowColor = UIColor(red: 0.96, green: 0.71, blue: 0.10, alpha: 1.0)   // #F4B41A

    // MARK: - UI-Элементы
    lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Что вы хотите выбросить?"
        search.backgroundImage = UIImage()
        search.backgroundColor = .clear
        
        if let textField = search.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white
            textField.font = .systemFont(ofSize: 15, weight: .medium)
            textField.textColor = darkTextColor
            textField.layer.cornerRadius = 16
            textField.layer.masksToBounds = false
            
            textField.layer.shadowColor = UIColor.black.cgColor
            textField.layer.shadowOpacity = 0.04
            textField.layer.shadowOffset = CGSize(width: 0, height: 4)
            textField.layer.shadowRadius = 8
            
            if let leftView = textField.leftView as? UIImageView {
                leftView.tintColor = accentYellowColor
            }
        }
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: - Свойства данных
    // ИСПРАВЛЕНО: Возвращаем правильный тип [TrashItem] для каталога поиска отходов
    var allItems: [TrashItem] = []
    var filteredItems: [TrashItem] = []
    var articlesData: [ArticleItem] = []
    var isSearching = false
    
    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainConfiguration()
        setupDelegates()
        setupLayout()
        setupMockData()
    }
    
    // MARK: - Первичная настройка
    private func setupMainConfiguration() {
        view.backgroundColor = appBgColor
        navigationItem.title = ""
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backTapped))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        
        let systemBackButton = UIBarButtonItem()
        systemBackButton.title = ""
        navigationItem.backBarButtonItem = systemBackButton
    }

    @objc private func backTapped() {
        if let nav = navigationController, nav.viewControllers.first != self {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func setupDelegates() {
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        // ИСПРАВЛЕНО: Регистрируем кастомные классы ЯЧЕЕК, которые мы создали ранее!
        tableView.register(CustomTrashCell.self, forCellReuseIdentifier: "TrashCell")
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: "ArticleCell")
    }
    
    private func setupLayout() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
