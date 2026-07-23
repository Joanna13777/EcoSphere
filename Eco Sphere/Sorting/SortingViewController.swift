import UIKit

class SortingViewController: UIViewController {

    // MARK: - Палитра цветов
    let appBgColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)       // #F5F5F5
    let darkTextColor = UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0)    // #1A1A1A

    // MARK: - UI-Элементы
    let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: - Свойства данных
    var articlesData: [ArticleItem] = []
    
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
        navigationItem.title = "Сортировка" // НАЗВАНИЕ ЭКРАНА
        
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
        tableView.dataSource = self
        tableView.delegate = self
        
        // Регистрируем только одну нужную ячейку для карточек статей
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: "ArticleCell")
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            // Таблица теперь занимает всё полезное пространство сверху донизу
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
