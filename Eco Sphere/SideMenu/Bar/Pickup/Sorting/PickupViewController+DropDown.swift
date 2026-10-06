import UIKit

// MARK: - Интеграция кастомного выпадающего списка строго ПОД полями
extension PickupViewController {
    
    enum DropDownType {
        case wasteType
        case pickupPoint
        case pickupAddress
    }
    
    // MARK: - UITextFieldDelegate
    // MARK: - UITextFieldDelegate
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == pickupAddressTextField {
            // Мягко закрываем другие списки, если они были открыты, но НЕ трогаем клавиатуру
            removeExistingDropDown()
            return true // Полностью разрешаем нативное редактирование и ввод текста
        }
        
        // Для остальных полей блокируем клавиатуру и открываем списки
        if textField == wasteTypeTextField || textField == pickupPointTextField {
            view.endEditing(true)
            if textField == wasteTypeTextField { wasteTypeFieldTapped() }
            if textField == pickupPointTextField { pickupPointFieldTapped() }
            return false
        }
        return true
    }
    
    
    // MARK: - Настройка кнопки Шеврона для Адреса
    /// Настраивает шеврон как отдельную кнопку, чтобы клик по нему вызывал выпадающий список
    func setupPickupAddressChevronMenu() {
        // 1. Создаем кнопку с современной конфигурацией iOS 15+
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "chevron.down")
        // Задаем отступ контента внутри кнопки (вместо contentEdgeInsets)
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 12)
        
        let chevronButton = UIButton(configuration: config, primaryAction: nil)
        chevronButton.tintColor = .systemGray2
        
        // Устанавливаем размеры кнопки
        chevronButton.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        
        // Назначаем действие при нажатии именно на эту кнопку
        chevronButton.addTarget(self, action: #selector(pickupAddressChevronTapped), for: .touchUpInside)
        
        // Устанавливаем кнопку в поле ввода
        pickupAddressTextField.rightView = chevronButton
        pickupAddressTextField.rightViewMode = .always
    }
    
    @objc private func pickupAddressChevronTapped() {
        // Убираем клавиатуру, если пользователь начал что-то писать руками, и разворачиваем меню
        view.endEditing(true)
        
        // Проверяем, открыто ли уже меню. Если да — закрываем его. Если нет — открываем.
        if view.viewWithTag(999) != nil {
            removeExistingDropDown()
        } else {
            showCustomDropDown(anchorField: pickupAddressTextField, type: .pickupAddress)
        }
    }
    
    // MARK: - Отображение кастомного DropDown
    func showCustomDropDown(anchorField: UITextField, type: DropDownType) {
        removeExistingDropDown()
        
        // ЧИТАЕМ ДАННЫЕ ИЗ НАШИХ МОДЕЛЕЙ
        var currentItems: [DropDownItem] = []
        
        if type == .wasteType {
            currentItems = PickupModelManager.shared.wasteItems
        } else if type == .pickupPoint {
            // Для приёмочного пункта подгружаем только хабы Ташкента
            let selectedWasteType = wasteTypeTextField.text ?? ""
            currentItems = PickupModelManager.shared.getAddresses(for: selectedWasteType)
        } else if type == .pickupAddress {
            //  ТЯНЕМ СВЕЖИЕ АДРЕСА С ЭКРАНА ИЗБРАННОГО ПРЯМО ИЗ ПАМЯТИ
            let savedAddresses = FavoriteAddressesManager.shared.loadAddresses()
            
            // Фирменный насыщенный желтый цвет как на вашем макете (#FBC02D)
            let favoriteYellowColor = UIColor(red: 251/255, green: 192/255, blue: 45/255, alpha: 1.0)
            
            currentItems = savedAddresses.map { favAddress in
                return DropDownItem(
                    title: favAddress.title,
                    subtitle: favAddress.address,
                    iconName: favAddress.iconName,    // Передаем "house.fill", "briefcase.fill", "leaf.fill"
                    iconColor: favoriteYellowColor    // Передаем ЖЕЛТЫЙ цвет в каждую ячейку списка!
                )
            }
        }
        
        // Защита-заглушка: показываем предупреждение, если список пуст
        let itemsToDisplay: [DropDownItem]
        if type == .pickupPoint && currentItems.isEmpty {
            itemsToDisplay = [DropDownItem(title: "Выберите сначала вид отхода", subtitle: "Поле выше не должно быть пустым", iconName: "exclamationmark.circle", iconColor: .systemGray)]
        } else if type == .pickupAddress && currentItems.isEmpty {
            itemsToDisplay = [DropDownItem(title: "Добавить адрес в профиле", subtitle: "У вас пока нет сохраненных адресов", iconName: "mappin.and.ellipse", iconColor: .systemGray)]
        } else {
            itemsToDisplay = currentItems
        }
        
        // Создаем выпадающее окно, передавая отфильтрованные данные
        let dropDownView = SortingDropDownView(items: itemsToDisplay)
        
        dropDownView.translatesAutoresizingMaskIntoConstraints = false
        dropDownView.tag = 999
        view.addSubview(dropDownView)
        
        // ОБРАБОТКА НАЖАТИЯ НА СТРОКУ СПИСКА
        dropDownView.onItemSelected = { [weak self] (selectedItem: DropDownItem) in
            if selectedItem.iconName == "exclamationmark.circle" { return }
            
            if selectedItem.title == "Добавить адрес в профиле" {
                self?.removeExistingDropDown()
                return
            }
            
            // Подставляем физический адрес (из subtitle) в текстовое поле
            let addressToSet = (type == .pickupAddress) ? selectedItem.subtitle : selectedItem.title
            anchorField.text = addressToSet
            
            // НАСТРОЙКА ЛЕВЫХ ИКОНОК ПОСЛЕ ВЫБОРА СТРОКИ В ПОЛЕ ВВОДА
            if type == .wasteType {
                self?.setFieldLeftIcon(anchorField, systemName: selectedItem.iconName, color: selectedItem.iconColor)
            } else if type == .pickupAddress {
                let favoriteYellowColor = UIColor(red: 251/255, green: 192/255, blue: 45/255, alpha: 1.0)
                
                // Передаем динамическую иконку (house.fill, briefcase.fill, leaf.fill) выбранной строки
                self?.setFieldLeftIcon(anchorField, systemName: selectedItem.iconName, color: favoriteYellowColor)
            } else {
                self?.setFieldLeftIcon(anchorField, systemName: "mappin.and.ellipse", color: .systemGray)
            }
            
            self?.validateFields()
            self?.updateSortingReminder()
            self?.removeExistingDropDown()
        }
        
        // Меняем стрелочку на "вверх" у кнопки шеврона текущего поля
        if let chevronButton = anchorField.rightView as? UIButton {
            var updatedConfig = chevronButton.configuration
            updatedConfig?.image = UIImage(systemName: "chevron.up")
            chevronButton.configuration = updatedConfig
        }
        
        let itemHeight: CGFloat = 64
        let padding: CGFloat = 8
        let calculatedHeight = CGFloat(itemsToDisplay.count) * itemHeight + padding
        let finalHeight = min(calculatedHeight, 390)
        
        NSLayoutConstraint.activate([
            dropDownView.topAnchor.constraint(equalTo: anchorField.bottomAnchor, constant: 4),
            dropDownView.leadingAnchor.constraint(equalTo: anchorField.leadingAnchor),
            dropDownView.trailingAnchor.constraint(equalTo: anchorField.trailingAnchor),
            dropDownView.heightAnchor.constraint(equalToConstant: finalHeight)
        ])
        
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(closeDropDownByTap))
        closeTap.cancelsTouchesInView = false
        view.addGestureRecognizer(closeTap)
    }
    
    
    
    
    // ПУНКТ 1: Метод установки иконки с увеличенным дочерним отступом для текста
    func setFieldLeftIcon(_ textField: UITextField, systemName: String, color: UIColor) {
        let iv = UIImageView(image: UIImage(systemName: systemName))
        iv.tintColor = color
        iv.contentMode = .scaleAspectFit
        
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 52, height: 24))
        iv.frame = CGRect(x: 16, y: 0, width: 24, height: 24)
        container.addSubview(iv)
        
        textField.leftView = container
        textField.leftViewMode = .always
    }
    
    @objc func closeDropDownByTap(gesture: UITapGestureRecognizer) {
        let touchPoint = gesture.location(in: view)
        if let existingView = view.viewWithTag(999), existingView.frame.contains(touchPoint) {
            return
        }
        // Если тапнули в любое другое место (включая пустое пространство) — закрываем меню
        removeExistingDropDown()
        
        // Удаляем сам жест с главного экрана, чтобы он больше не перехватывал нажатия
        view.removeGestureRecognizer(gesture)
    }
    
    func removeExistingDropDown() {
        // Возвращаем стрелочку шеврона обратно в положение "вниз"
        if let chevronButton = pickupAddressTextField.rightView as? UIButton {
            var updatedConfig = chevronButton.configuration
            updatedConfig?.image = UIImage(systemName: "chevron.down")
            chevronButton.configuration = updatedConfig
        } else {
            pickupAddressTextField.setRightImage(systemName: "chevron.down", tintColor: .systemGray2)
        }
        
        wasteTypeTextField.setRightImage(systemName: "chevron.down", tintColor: .systemGray2)
        pickupPointTextField.setRightImage(systemName: "chevron.down", tintColor: .systemGray2)
        
        // Находим меню по тегу
        if let existingView = view.viewWithTag(999) {
            UIView.animate(withDuration: 0.15, animations: {
                existingView.alpha = 0
            }) { _ in
                existingView.removeFromSuperview()
            }
        }
    }
}
