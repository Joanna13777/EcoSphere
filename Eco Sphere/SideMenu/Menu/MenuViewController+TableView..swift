import UIKit

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Синхронизация данных профиля с шапкой меню
    @objc func updateHeaderView() {
        let defaults = UserDefaults.standard
        
        let savedName = defaults.string(forKey: "user_profile_name") ?? "Имя не указано"
        let savedPhone = defaults.string(forKey: "user_profile_phone") ?? "Номер не указан"
        
        // ИСПРАВЛЕНО: Передаем текст в реальные UI-компоненты
        headerNameLabel.text = savedName.isEmpty ? "Имя не указано" : savedName
        headerPhoneLabel.text = savedPhone.isEmpty ? "Номер не указан" : savedPhone
        
        // Загружаем картинку аватара
        if let avatarData = defaults.data(forKey: "user_profile_avatar_data"),
           let savedImage = UIImage(data: avatarData) {
            headerAvatarImageView.image = savedImage
        } else {
            headerAvatarImageView.image = UIImage(systemName: "person.crop.circle.fill")
        }
        
        print("Шапка меню синхронизирована с базой: \(savedName)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    // иконки экрана Меню
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.selectionStyle = .none
        
        // Проверяем статус авторизации пользователя
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "menu_user_logged_in")
        
        // Настройка стандартных строк (от 0 до 5)
        if indexPath.row < 6 {
            cell.textLabel?.text = menuItems[indexPath.row]
            cell.textLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            cell.textLabel?.textColor = .label
            cell.imageView?.image = UIImage(systemName: menuIcons[indexPath.row])
            cell.imageView?.tintColor = .label
        } else {
            // --- ДИНАМИЧЕСКАЯ 6-я СТРОКА (ВЫХОД / ВХОД) ---
            cell.textLabel?.font = .systemFont(ofSize: 16, weight: .semibold) // Сделаем чуть акцентнее
            
            if isUserLoggedIn {
                // Если вошел: показываем "Выход" (строгий стиль, цвет темы)
                cell.textLabel?.text = "Выход"
                cell.textLabel?.textColor = .label
                cell.imageView?.image = UIImage(systemName: "arrow.left.to.line.compact")
                cell.imageView?.tintColor = .label
            } else {
                // Если НЕ вошел (гость): меняем на "Вход в аккаунт" зеленым эко-цветом!
                cell.textLabel?.text = "Вход в аккаунт"
                cell.textLabel?.textColor = .label
                cell.imageView?.image = UIImage(systemName: "arrow.right.to.line.compact")
                cell.imageView?.tintColor = .label
            }
        }
        
        return cell
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Названия элементов в массиве: индексы под 7 пунктов меню:
        switch indexPath.row {
        case 0: // Вывоз вторсырья
            let vc = PickupViewController()
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.pushViewController(vc, animated: true)
            
        case 1: // История
            let vc = HistoryViewController()
            vc.title = menuItems[indexPath.row]
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.pushViewController(vc, animated: true)
            
        case 2: // Избранные адреса
            let favoriteVC = FavoriteAddressesViewController()
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.pushViewController(favoriteVC, animated: true)
            
        case 3: // Обратная связь
            let vc = FeedbackViewController()
            vc.title = menuItems[indexPath.row]
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.pushViewController(vc, animated: true)
            
        case 4: // Связаться с нами (Кнопки телефона, ТГ и почты)
            let vc = ContactsViewController()
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.pushViewController(vc, animated: true)
            
        case 5: // О приложении (Условия и правила договора)
            let vc = AboutViewController()
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.pushViewController(vc, animated: true)
  
        case 6: // Динамическая строка (Выход / Вход)
            let isUserLoggedIn = UserDefaults.standard.bool(forKey: "menu_user_logged_in")
            
            if isUserLoggedIn {
                // СЦЕНАРИЙ А: Пользователь авторизован -> Показываем алерт ВЫХОДА
                let alert = UIAlertController(title: "Выйти из аккаунта?", message: "Вы точно хотите выйти из аккаунта?", preferredStyle: .alert)
                
                let logoutAction = UIAlertAction(title: "Выйти", style: .destructive) { [weak self] _ in
                    guard let self = self else { return }
                    
                    UserDefaults.standard.set(false, forKey: "menu_user_logged_in")
                    UserDefaults.standard.removeObject(forKey: "user_profile_name")
                    UserDefaults.standard.removeObject(forKey: "user_profile_phone")
                    UserDefaults.standard.removeObject(forKey: "user_profile_avatar_data")
                    UserDefaults.standard.removeObject(forKey: "is_agreement_accepted")
                                    
                    self.updateHeaderView()
                    
                    // Мгновенно перезагружаем таблицу меню, чтобы "Выход" поменялся на "Вход" на лету!
                    self.tableView.reloadData()
                }
                let cancelAction = UIAlertAction(title: "Остаться", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                alert.addAction(logoutAction)
                present(alert, animated: true, completion: nil)
                
            } else {
                // СЦЕНАРИЙ Б: Пользователь НЕ авторизован -> Открываем экран ВХОДА
                let signInVC = AuthSignInViewController()
                navigationController?.setNavigationBarHidden(false, animated: true)
                navigationController?.pushViewController(signInVC, animated: true)
            }
            
        default:
            break
        }

    }
    
    // Переход в профиль по клику на шапку
    @objc func openProfileDetails() {
        let editProfileVC = EditProfileViewController()
        editProfileVC.delegate = self // Меню слушает профиль
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
}

// MARK: - EditProfileDelegate
extension MenuViewController: EditProfileDelegate {
    func didUpdateProfileData() {
        updateHeaderView()
    }
}
