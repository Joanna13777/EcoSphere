import UIKit

class MenuViewController: UIViewController {
    
    let menuItems = ["Вывоз вторсырья", "История", "Избранные адреса", "Обратная связь", "О приложении", "Выход"]
    let menuIcons = ["truck.box", "clock.arrow.circlepath", "star", "bubble.left.and.bubble.right", "info.circle", "power"]
    
    // Кастомный красивый тёмно-серый цвет (как в iOS)
    let customDarkGray = UIColor(red: 0.12, green: 0.12, blue: 0.13, alpha: 1.0)
    
    // MARK: - Таблица
    let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.separatorStyle = .singleLine
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let themeLabel: UILabel = {
        let label = UILabel()
        label.text = "Тёмная тема"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let themeSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = UIColor(red: 0.98, green: 0.82, blue: 0.24, alpha: 1.0)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIColor.applyGlobalTheme(for: self)
        
        setupLayout()
        setupTableView()
        setupActions()
        
        let currentTheme = UserDefaults.standard.integer(forKey: "selected_app_theme")
        themeSwitch.isOn = (currentTheme == 1)
        
        // Назначаем адаптивный фон экрану меню при первой загрузке
        view.backgroundColor = .appBackground
        tableView.backgroundColor = .appBackground
        tableView.separatorColor = .appSeparator
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateHeaderView()
        
        // БЕЗОПАСНАЯ НАСТРОЙКА: Красим экран и таблицу через наш единый метод
        UIColor.applyGlobalTheme(for: self, withTableView: tableView)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc private func themeChanged(_ sender: UISwitch) {
        // 1. Меняем тему в глобальном менеджере
        if sender.isOn {
            ThemeManager.shared.applyTheme(.dark)
        } else {
            ThemeManager.shared.applyTheme(.light)
        }
        
        // 2. Мгновенно обновляем цвета текущего экрана меню и его шапки
        view.backgroundColor = .appBackground
        tableView.backgroundColor = .appBackground
        tableView.separatorColor = .appSeparator
        themeLabel.textColor = .label
        updateHeaderView()
        
        // 3. Принудительно перезагружаем таблицу, чтобы ячейки поменяли цвета
        tableView.reloadData()
    }

    
    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(themeLabel)
        view.addSubview(themeSwitch)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: themeSwitch.topAnchor, constant: -16),
            
            themeSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            themeSwitch.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            themeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            themeLabel.centerYAnchor.constraint(equalTo: themeSwitch.centerYAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MenuCell")
        tableView.tableFooterView = UIView()
    }
    
    private func setupActions() {
        themeSwitch.addTarget(self, action: #selector(themeChanged), for: .valueChanged)
    }
    
    // MARK: - Управление цветами экрана и Нижнего Бара (Tab Bar)
    func applyThemeColors(isDark: Bool) {
        let backgroundColor = ThemeManager.shared.appBackgroundColor
        
        view.backgroundColor = backgroundColor
        tableView.backgroundColor = backgroundColor
        tableView.separatorColor = ThemeManager.shared.appSeparatorColor
        themeLabel.textColor = .label
    }

    
    @objc func menuRegisterButtonTapped() {
        let loginVC = LoginViewController()
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.pushViewController(loginVC, animated: true)
    }
}
