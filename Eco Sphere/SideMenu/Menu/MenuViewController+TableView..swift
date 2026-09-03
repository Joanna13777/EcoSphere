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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        cell.textLabel?.text = menuItems[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cell.textLabel?.textColor = .label
        
        cell.imageView?.image = UIImage(systemName: menuIcons[indexPath.row])
        cell.imageView?.tintColor = indexPath.row == 5 ? .systemRed : .label
        
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Названия элементов в массиве:
        // 0: Вывоз вторсырья, 1: История, 2: Избранные адреса, 3: Обратная связь, 4: О приложении, 5: Выход
        switch indexPath.row {
        case 0:
            let vc = PickupViewController()
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.pushViewController(vc, animated: true)
            
        case 1:
            let vc = HistoryViewController()
            vc.title = menuItems[indexPath.row]
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.pushViewController(vc, animated: true)
            
        case 2:
            let favoriteVC = FavoriteAddressesViewController()
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.pushViewController(favoriteVC, animated: true)
            
        case 3: // Строка "Обратная связь"
            let feedbackVC = FeedbackViewController()
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.pushViewController(feedbackVC, animated: true)
            
        case 4:
            let vc = AboutViewController()
            vc.title = menuItems[indexPath.row]
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.pushViewController(vc, animated: true)
            
        case 5:
            let alert = UIAlertController(title: "Выйти из аккаунта?", message: "Вы точно хотите выйти из аккаунта?", preferredStyle: .alert)
            let logoutAction = UIAlertAction(title: "Выйти", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                UserDefaults.standard.set(false, forKey: "menu_user_logged_in")
                UserDefaults.standard.removeObject(forKey: "user_profile_name")
                UserDefaults.standard.removeObject(forKey: "user_profile_phone")
                UserDefaults.standard.removeObject(forKey: "user_profile_avatar_data")
                self.updateHeaderView()
                
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
