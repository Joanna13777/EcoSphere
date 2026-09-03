import UIKit

class SortingViewController: UIViewController {

    // MARK: - UI-Элементы
    let tableView: UITableView = {
        let table = UITableView()
        // ВАЖНО: Используем наш единый цвет из файла UIColor+Theme.swift
        table.backgroundColor = .appBackground
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
        
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: "ArticleCell")
        
        setupMockData()
        setupMainConfiguration()
        setupDelegates()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Красим фон, поля, навигационный бар
            UIColor.applyGlobalTheme(for: self)
        
        // 2. НАСТРОЙКА ВЕРХНЕГО БАРА (Делаем стрелочку "Назад" и заголовок светлыми)
        if let navBar = navigationController?.navigationBar {
            let isDark = UserDefaults.standard.integer(forKey: "selected_app_theme") == 1
            let themeColor = UIColor.appBackground
            
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = themeColor
            
            // Текст заголовка вверху станет белым в тёмной теме
            appearance.titleTextAttributes = [.foregroundColor: isDark ? UIColor.white : UIColor.black]
            
            navBar.standardAppearance = appearance
            navBar.scrollEdgeAppearance = appearance
            
            // Сама стрелочка "Назад" станет белой в тёмной теме
            navBar.tintColor = isDark ? UIColor.white : UIColor.black
        }
        
        // 3. Страховка для кастомной UIBarButtonItem кнопки "Назад" (если создавали вручную)
        if let backButton = navigationItem.leftBarButtonItem {
            let isDark = UserDefaults.standard.integer(forKey: "selected_app_theme") == 1
            backButton.tintColor = isDark ? .white : .black
        }
    }

    
    // MARK: - Первичная настройка
    private func setupMainConfiguration() {
        view.backgroundColor = .appBackground
        navigationItem.title = "Сортировка"
        
        let isDark = UserDefaults.standard.integer(forKey: "selected_app_theme") == 1
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backTapped))
        // Адаптивный цвет стрелочки «Назад»
        backButton.tintColor = isDark ? .white : .black
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
        
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: "ArticleCell")
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
