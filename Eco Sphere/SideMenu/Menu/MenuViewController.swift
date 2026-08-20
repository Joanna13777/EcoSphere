import UIKit

class MenuViewController: UIViewController {
    
    // Элементы меню
    private let menuItems = ["Вывоз вторсырья", "История", "Избранные адреса", "Обратная связь", "О приложении", "Выход"]
    private let menuIcons = ["truck.box", "clock.arrow.circlepath", "star", "bubble.left.and.bubble.right", "info.circle", "power"]
    
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.backgroundColor = .white
        tv.separatorStyle = .singleLine
        tv.separatorColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.0)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupTableView()
        
        // Скрываем пустой бар сразу при первой загрузке экрана
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Обновляем шапку при каждом открытии меню (профиль / кнопка входа)
        updateHeaderView()
        
        // Гарантированно убираем пустую верхнюю полосу
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MenuCell")
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - При клике на черную кнопку «Войти / Регистрация» в боковом меню открывался именно этот новый экран входа `LoginViewController`.
    @objc private func menuRegisterButtonTapped() {
            // Теперь открываем новый, чистый экран входа
            let loginVC = LoginViewController()
            
            // Показываем верхний бар со стрелочкой "Назад", чтобы пользователь мог вернуться в меню
            navigationController?.setNavigationBarHidden(false, animated: true)
            
            // Переходим на экран входа
            navigationController?.pushViewController(loginVC, animated: true)
        }
    
    // MARK: - Динамическая Шапка (Профиль или Кнопка входа)
    private func updateHeaderView() {
        let isLoggedIn = UserDefaults.standard.bool(forKey: "menu_user_logged_in")
        let headerContainer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 120))
        headerContainer.backgroundColor = .white
        
        if isLoggedIn {
            // --- СОСТОЯНИЕ 1: ПОЛЬЗОВАТЕЛЬ АВТОРИЗОВАН ---
            let avatarView = UIView()
            avatarView.backgroundColor = UIColor(red: 0.90, green: 0.95, blue: 0.90, alpha: 1.0)
            avatarView.layer.cornerRadius = 30
            avatarView.translatesAutoresizingMaskIntoConstraints = false
            
            let avatarIcon = UIImageView(image: UIImage(systemName: "person.crop.circle.fill"))
            avatarIcon.tintColor = .systemGray
            avatarIcon.translatesAutoresizingMaskIntoConstraints = false
            avatarView.addSubview(avatarIcon)
            
            let nameLabel = UILabel()
            let savedName = UserDefaults.standard.string(forKey: "menu_user_name") ?? "Пользователь"
            nameLabel.text = savedName
            nameLabel.font = .systemFont(ofSize: 18, weight: .semibold)
            nameLabel.textColor = .black
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let cityLabel = UILabel()
            cityLabel.text = "Ташкент"
            cityLabel.font = .systemFont(ofSize: 14, weight: .regular)
            cityLabel.textColor = .systemGray
            cityLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
            chevronImageView.tintColor = .systemGray2
            chevronImageView.translatesAutoresizingMaskIntoConstraints = false
            
            headerContainer.addSubview(avatarView)
            headerContainer.addSubview(nameLabel)
            headerContainer.addSubview(cityLabel)
            headerContainer.addSubview(chevronImageView)
            
            NSLayoutConstraint.activate([
                avatarView.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 24),
                avatarView.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),
                avatarView.widthAnchor.constraint(equalToConstant: 60),
                avatarView.heightAnchor.constraint(equalToConstant: 60),
                
                avatarIcon.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
                avatarIcon.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
                avatarIcon.widthAnchor.constraint(equalTo: avatarView.widthAnchor),
                avatarIcon.heightAnchor.constraint(equalTo: avatarView.heightAnchor),
                
                nameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 16),
                nameLabel.topAnchor.constraint(equalTo: avatarView.topAnchor, constant: 8),
                nameLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -16),
                
                cityLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
                cityLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
                
                chevronImageView.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -24),
                chevronImageView.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),
                chevronImageView.widthAnchor.constraint(equalToConstant: 12),
                chevronImageView.heightAnchor.constraint(equalToConstant: 20)
            ])
            
        } else {
            // --- СОСТОЯНИЕ 2: ГОСТЬ (Показываем кнопку регистрации) ---
            let registerButton = UIButton(type: .system)
            registerButton.setTitle("Войти / Регистрация", for: .normal)
            registerButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
            registerButton.backgroundColor = UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0)
            registerButton.setTitleColor(.white, for: .normal)
            registerButton.layer.cornerRadius = 16
            registerButton.translatesAutoresizingMaskIntoConstraints = false
            registerButton.addTarget(self, action: #selector(menuRegisterButtonTapped), for: .touchUpInside)
            
            headerContainer.addSubview(registerButton)
            
            NSLayoutConstraint.activate([
                registerButton.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 24),
                registerButton.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -24),
                registerButton.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),
                registerButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        
        let bottomSeparator = UIView()
        bottomSeparator.backgroundColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.0)
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(bottomSeparator)
        
        NSLayoutConstraint.activate([
            bottomSeparator.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor),
            bottomSeparator.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor),
            bottomSeparator.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor),
            bottomSeparator.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        tableView.tableHeaderView = headerContainer
    }
}

// MARK: - TableView Конфигурация
extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cell.textLabel?.textColor = .black
        
        cell.imageView?.image = UIImage(systemName: menuIcons[indexPath.row])
        cell.imageView?.tintColor = indexPath.row == 5 ? .systemRed : .black
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Снимаем выделение с ячейки, чтобы она не оставалась серой
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0: // Вывоз вторсырья
            let vc = PickupViewController()
            vc.title = menuItems[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            
        case 1: // История
            let vc = HistoryViewController()
            vc.title = menuItems[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            
        case 2: // Избранные адреса
            let vc = SavedAddressesViewController()
            vc.title = menuItems[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            
        case 3: // Обратная связь
            let vc = FeedbackViewController()
            vc.title = menuItems[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            
        case 4: // О приложении
            let vc = AboutViewController()
            vc.title = menuItems[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            
        case 5: // Выход
            // Создаем диалоговое окно с подтверждением выхода
            let alert = UIAlertController(
                title: "Выйти из аккаунта?",
                message: "Вы точно хотите выйти из аккаунта?",
                preferredStyle: .alert
            )
            
            // 1. Кнопка "Выйти"
            let logoutAction = UIAlertAction(title: "Выйти", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                
                // Стираем данные авторизации
                UserDefaults.standard.set(false, forKey: "menu_user_logged_in")
                UserDefaults.standard.removeObject(forKey: "menu_user_name")
                
                self.updateHeaderView()
                tableView.reloadData()
                
                // Теперь создаем и пушим именно LoginViewController,
                // так как логика входа находится в нем и в его расширении
                let loginVC = LoginViewController()
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.navigationController?.pushViewController(loginVC, animated: true)
            }
            
            // 2. Кнопка "Остаться" (стиль .cancel закроет окно без действий)
            let cancelAction = UIAlertAction(title: "Остаться", style: .cancel, handler: nil)
            
            // Добавляем кнопки в окно (кнопка отмены системно встанет слева или внизу для удобства)
            alert.addAction(cancelAction)
            alert.addAction(logoutAction)
            
            // Показываем окно пользователю
            present(alert, animated: true, completion: nil)

            
        default:
            break
        }
    }
    // Пример кода перехода в обработчик клика по профилю в Меню:
    @objc private func openProfileDetails() {
        let editProfileVC = EditProfileViewController()
        
        // Если меню открыто внутри NavigationController:
        if let navigationController = self.navigationController {
            navigationController.pushViewController(editProfileVC, animated: true)
        } else {
            // Если навигационного бара нет — открываем модально на весь экран
            editProfileVC.modalPresentationStyle = .fullScreen
            self.present(editProfileVC, animated: true, completion: nil)
        }
    }


}


// MARK: - Canvas Preview (Отображение двух состояний меню)
#Preview("Вход выполнен (Профиль)") {
    // Симулируем в памяти состояние успешного входа для этого превью
    UserDefaults.standard.set(true, forKey: "menu_user_logged_in")
    UserDefaults.standard.set("Иван Иванов", forKey: "menu_user_name")
    
    let menuVC = MenuViewController()
    return menuVC
}

#Preview("Гость (Кнопка Регистрации)") {
    // Симулируем в памяти состояние гостя для этого превью
    UserDefaults.standard.set(false, forKey: "menu_user_logged_in")
    
    let menuVC = MenuViewController()
    return menuVC
}
