import UIKit

class MenuViewController: UIViewController {
    
    let menuItems = ["Вывоз вторсырья", "История", "Избранные адреса", "Обратная связь", "Связаться с нами", "О приложении", "Выход"]
    let menuIcons = ["truck.box", "clock.arrow.circlepath", "star", "bubble.left.and.bubble.right", "phone.circle", "info.circle", "power"]
    
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
        
        // --- ГЛАВНОЕ ИСПРАВЛЕНИЕ: Запрещаем контенту залезать ПОД навигационный бар ---
                // Это автоматически сдвинет таблицу вниз ровно под линию бара, и колокольчик появится!
                self.edgesForExtendedLayout = []
        
        UIColor.applyGlobalTheme(for: self)
        
        setupLayout()
        setupTableView()
        setupActions()
        setupNotificationNavigationButton()
        
        // Включаем колокольчик в углу нативного бара
                setupNotificationNavigationButton()
        
        let currentTheme = UserDefaults.standard.integer(forKey: "selected_app_theme")
        themeSwitch.isOn = (currentTheme == 1)
        
        // Назначаем адаптивный фон экрану меню при первой загрузке
        view.backgroundColor = .appBackground
        tableView.backgroundColor = .appBackground
        tableView.separatorColor = .appSeparator
        
        // Слушаем изменения статуса специально для колокольчика в таблице меню
                NotificationCenter.default.addObserver(self, selector: #selector(updateMenuBellColor), name: NSNotification.Name("AppNotificationStatusChanged"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateHeaderView()
        updateMenuBellColor() // обновление цвета принудительно, чтобы при возвращении назад из других экранов цвет обновлялся мгновенно
        
        tableView.reloadData() // Принудительно обновляем таблицу при каждом показе меню
        
        title = "Меню"
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
        
        // --- СОЗДАЕМ КОНТЕЙНЕР ШАПКИ С УЧЕТОМ КОЛОКОЛЬЧИКА ---
        let headerContainer = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 100))
        headerContainer.backgroundColor = .clear
        headerContainer.autoresizingMask = [.flexibleWidth]
        
        // 1. Создаем локальную кнопку уведомлений
        let bellButton = UIButton(type: .system)
        bellButton.setImage(UIImage(systemName: "bell.fill"), for: .normal)
        bellButton.tintColor = .label // Адаптивный цвет (черный/белый)
        // Привязываем нажатие к методу перехода, который мы написали в расширении
        bellButton.addTarget(self, action: #selector(menuNotificationTapped), for: .touchUpInside)
        bellButton.translatesAutoresizingMaskIntoConstraints = false
        
        // 2. Добавляем все элементы на подложку
        headerContainer.addSubview(headerAvatarImageView)
        headerContainer.addSubview(headerNameLabel)
        headerContainer.addSubview(headerPhoneLabel)
        headerContainer.addSubview(bellButton) // <-- Добавили колокольчик в шапку
        
        NSLayoutConstraint.activate([
            // Аватар
            headerAvatarImageView.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 20),
            headerAvatarImageView.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),
            headerAvatarImageView.widthAnchor.constraint(equalToConstant: 60),
            headerAvatarImageView.heightAnchor.constraint(equalToConstant: 60),
            
            // КНОПКА КОЛОКОЛЬЧИКА: Прижимаем к правому верхнему углу шапки профиля
            bellButton.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -24),
            bellButton.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: 16),
            bellButton.widthAnchor.constraint(equalToConstant: 32),
            bellButton.heightAnchor.constraint(equalToConstant: 32),
            
            // Лейбл имени (ограничиваем его правый край до колокольчика, чтобы текст не налезал на иконку)
            headerNameLabel.leadingAnchor.constraint(equalTo: headerAvatarImageView.trailingAnchor, constant: 16),
            headerNameLabel.trailingAnchor.constraint(equalTo: bellButton.leadingAnchor, constant: -12),
            headerNameLabel.topAnchor.constraint(equalTo: headerAvatarImageView.topAnchor, constant: 4),
            
            // Телефон
            headerPhoneLabel.leadingAnchor.constraint(equalTo: headerNameLabel.leadingAnchor),
            headerPhoneLabel.trailingAnchor.constraint(equalTo: headerNameLabel.trailingAnchor),
            headerPhoneLabel.topAnchor.constraint(equalTo: headerNameLabel.bottomAnchor, constant: 4)
        ])
        
        // Назначаем готовую шапку в таблицу
        tableView.tableHeaderView = headerContainer
        
        // Делаем шапку кликабельной для перехода в профиль (при тапе на аватар или имя)
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
    
    
    @objc func menuNotificationTapped() {
        let notificationVC = NotificationCenterViewController()
        
        if let navController = navigationController {
            navController.setNavigationBarHidden(false, animated: true)
            navController.pushViewController(notificationVC, animated: true)
        } else {
            let navController = UINavigationController(rootViewController: notificationVC)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true, completion: nil)
        }
    }
    
    /// кнопку колокольчика в шапке таблицы и перекрашивать её
    @objc private func updateMenuBellColor() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                  let headerContainer = self.tableView.tableHeaderView else { return }
            
            // Ищем кнопку колокольчика среди подвью контейнера шапки
            if let bellButton = headerContainer.subviews.first(where: { $0 is UIButton }) as? UIButton {
                let hasUnread = NotificationManager.shared.hasUnread()
                bellButton.tintColor = hasUnread ? .systemGreen : .label
                bellButton.setImage(UIImage(systemName: hasUnread ? "bell.badge.fill" : "bell.fill"), for: .normal)
            }
        }
    }
}
