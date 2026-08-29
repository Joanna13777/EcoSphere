import UIKit

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func updateHeaderView() {
        let isLoggedIn = UserDefaults.standard.bool(forKey: "menu_user_logged_in")
        let headerContainer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 120))
        
        let isDark = themeSwitch.isOn
        headerContainer.backgroundColor = isDark ? customDarkGray : UIColor.white
        
        if isLoggedIn {
            // --- СОСТОЯНИЕ 1: ПОЛЬЗОВАТЕЛЬ АВТОРИЗОВАН ---
            let avatarView = UIView()
            avatarView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)
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
            nameLabel.textColor = isDark ? .white : .black
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let cityLabel = UILabel()
            cityLabel.text = "Ташкент"
            cityLabel.font = .systemFont(ofSize: 14, weight: .regular)
            cityLabel.textColor = .systemGray
            cityLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
            chevronImageView.tintColor = .systemGray2
            chevronImageView.translatesAutoresizingMaskIntoConstraints = false
            
            // ВАЖНОЕ ИСПРАВЛЕНИЕ: Сначала ОБЯЗАТЕЛЬНО добавляем все дочерние элементы в контейнер
            headerContainer.addSubview(avatarView)
            headerContainer.addSubview(nameLabel)
            headerContainer.addSubview(cityLabel)
            headerContainer.addSubview(chevronImageView)
            
            // И ТОЛЬКО ТЕПЕРЬ, когда они находятся внутри одной иерархии, активируем констрейнты!
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
            
            headerContainer.isUserInteractionEnabled = true
            let headerTap = UITapGestureRecognizer(target: self, action: #selector(openProfileDetails))
            headerContainer.addGestureRecognizer(headerTap)
            
        } else {
            // --- СОСТОЯНИЕ 2: ГОСТЬ ---
            let registerButton = UIButton(type: .system)
            registerButton.setTitle("Войти / Регистрация", for: .normal)
            registerButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
            registerButton.backgroundColor = isDark ? .white : .black
            registerButton.setTitleColor(isDark ? .black : .white, for: .normal)
            registerButton.layer.cornerRadius = 16
            registerButton.translatesAutoresizingMaskIntoConstraints = false
            registerButton.addTarget(self, action: #selector(menuRegisterButtonTapped), for: .touchUpInside)
            
            // Сначала добавляем на экран
            headerContainer.addSubview(registerButton)
            
            // Потом активируем констрейнты
            NSLayoutConstraint.activate([
                registerButton.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 24),
                registerButton.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -24),
                registerButton.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),
                registerButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        
        let bottomSeparator = UIView()
        bottomSeparator.backgroundColor = isDark ? UIColor(red: 0.22, green: 0.22, blue: 0.24, alpha: 1.0) : UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.0)
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        // Сначала добавляем линию разделителя
        headerContainer.addSubview(bottomSeparator)
        
        // Потом её констрейнты
        NSLayoutConstraint.activate([
            bottomSeparator.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor),
            bottomSeparator.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor),
            bottomSeparator.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor),
            bottomSeparator.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        tableView.tableHeaderView = headerContainer
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        
        // Полностью очищаем фоны ячеек под адаптивный цвет таблицы
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        cell.textLabel?.text = menuItems[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        
        // === ИСПРАВЛЕНИЕ 1: Системный .label сам сделает текст черным в светлой теме ===
        cell.textLabel?.textColor = .label
        
        cell.imageView?.image = UIImage(systemName: menuIcons[indexPath.row])
        
        // === ИСПРАВЛЕНИЕ 2: Системный .label сам перекрасит иконки в черный/белый ===
        cell.imageView?.tintColor = indexPath.row == 5 ? .systemRed : .label
        
        cell.selectionStyle = .none
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            navigationController?.setNavigationBarHidden(false, animated: true)
            let vc = PickupViewController()
            navigationController?.pushViewController(vc, animated: true)
            
        case 1:
            navigationController?.setNavigationBarHidden(false, animated: true)
            let vc = HistoryViewController()
            vc.title = menuItems[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            
        case 2:
//            navigationController?.setNavigationBarHidden(false, animated: true)
//            let vc = FavoriteAddressesViewController()
//            vc.title = menuItems[indexPath.row]
//            navigationController?.pushViewController(vc, animated: true)
            
            if indexPath.row == 2 { // "Избранные адреса"
                    let favoriteVC = FavoriteAddressesViewController()
                    navigationController?.setNavigationBarHidden(false, animated: true)
                    navigationController?.pushViewController(favoriteVC, animated: true)
                }
            
        case 3:
            navigationController?.setNavigationBarHidden(false, animated: true)
            let vc = FeedbackViewController()
            vc.title = menuItems[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            
        case 4:
            navigationController?.setNavigationBarHidden(false, animated: true)
            let vc = AboutViewController()
            vc.title = menuItems[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
            
        case 5:
            let alert = UIAlertController(title: "Выйти из аккаунта?", message: "Вы точно хотите выйти из аккаунта?", preferredStyle: .alert)
            let logoutAction = UIAlertAction(title: "Выйти", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                UserDefaults.standard.set(false, forKey: "menu_user_logged_in")
                UserDefaults.standard.removeObject(forKey: "menu_user_name")
                self.updateHeaderView()
                tableView.reloadData()
                
                let loginVC = LoginViewController()
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.navigationController?.pushViewController(loginVC, animated: true)
            }
            let cancelAction = UIAlertAction(title: "Остаться", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            alert.addAction(logoutAction)
            present(alert, animated: true, completion: nil)
            
        default:
            break
        }
    }
    
    @objc func openProfileDetails() {
        let editProfileVC = EditProfileViewController()
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
}
