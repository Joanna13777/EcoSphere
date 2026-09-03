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
    
    // MARK: - Элементы шапки профиля (Вставьте под themeSwitch)
    let headerAvatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person.crop.circle.fill")
        iv.tintColor = .systemGray3
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 30 // Круг радиусом 60x60
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let headerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Имя не указано"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label // Адаптивный цвет (черный/белый)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let headerPhoneLabel: UILabel = {
        let label = UILabel()
        label.text = "Номер не указан"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        
        // СОЗДАЕМ КОНТЕЙНЕР ШАПКИ С ЖЕСТКИМИ БЕЗОПАСНЫМИ ТЕКУЩИМИ РАЗМЕРАМИ ---
        // Используем ширину экрана view.bounds.width вместо нуля, чтобы исключить NaN ошибки
        let headerContainer = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 100))
        headerContainer.backgroundColor = .clear
        
        // Включаем авторезирование, чтобы UIKit правильно считывал размеры контейнера внутри таблицы
        headerContainer.autoresizingMask = [.flexibleWidth]
        
        headerContainer.addSubview(headerAvatarImageView)
        headerContainer.addSubview(headerNameLabel)
        headerContainer.addSubview(headerPhoneLabel)
        
        NSLayoutConstraint.activate([
            // Привязываем аватар к левому краю контейнера
            headerAvatarImageView.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 20),
            headerAvatarImageView.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),
            headerAvatarImageView.widthAnchor.constraint(equalToConstant: 60),
            headerAvatarImageView.heightAnchor.constraint(equalToConstant: 60),
            
            // Привязываем лейбл имени
            headerNameLabel.leadingAnchor.constraint(equalTo: headerAvatarImageView.trailingAnchor, constant: 16),
            // Привязываем строго к краям CONTAINER, а не абстрактных вьюх
            headerNameLabel.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -20),
            headerNameLabel.topAnchor.constraint(equalTo: headerAvatarImageView.topAnchor, constant: 4),
            
            // Привязываем телефон
            headerPhoneLabel.leadingAnchor.constraint(equalTo: headerNameLabel.leadingAnchor),
            headerPhoneLabel.trailingAnchor.constraint(equalTo: headerNameLabel.trailingAnchor),
            headerPhoneLabel.topAnchor.constraint(equalTo: headerNameLabel.bottomAnchor, constant: 4)
        ])
        
        // Назначаем контейнер в таблицу
        tableView.tableHeaderView = headerContainer
        
        // Делаем шапку кликабельной для перехода в профиль
        let tap = UITapGestureRecognizer(target: self, action: #selector(openProfileDetails))
        headerContainer.addGestureRecognizer(tap)
    }


    
    private func setupActions() {
        themeSwitch.addTarget(self, action: #selector(themeChanged), for: .valueChanged)
    }
    

    @objc func menuRegisterButtonTapped() {
        let loginVC = LoginViewController()
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.pushViewController(loginVC, animated: true)
    }
}
