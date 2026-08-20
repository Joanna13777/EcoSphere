import UIKit

// MARK: - Интеграция кастомного выпадающего списка строго ПОД полями
extension PickupViewController {
    
    enum DropDownType {
        case wasteType
        case pickupPoint
    }
    
    // Перехватываем нажатие на поле, блокируем клавиатуру и разворачиваем кастомное меню
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == wasteTypeTextField {
            showCustomDropDown(anchorField: wasteTypeTextField, type: .wasteType)
            return false
        }
        
        if textField == pickupPointTextField {
            showCustomDropDown(anchorField: pickupPointTextField, type: .pickupPoint)
            return false
        }
        
        return true
    }
    
    func showCustomDropDown(anchorField: UITextField, type: DropDownType) {
        removeExistingDropDown()
        
        // ЧИТАЕМ ДАННЫЕ ИЗ НАШЕЙ НОВОЙ МОДЕЛИ PICKUPMODEL.SWIFT
        let currentItems: [DropDownItem]
        
        if type == .wasteType {
            // Берем готовый полный список видов сырья из менеджера моделей
            currentItems = PickupModelManager.shared.wasteItems
        } else {
            // Извлекаем название отхода, выбранного пользователем в первом поле
            let selectedWasteType = wasteTypeTextField.text ?? ""
            
            // Фильтруем адреса: модель отдаст только те пункты, которые принимают этот тип сырья
            currentItems = PickupModelManager.shared.getAddresses(for: selectedWasteType)
        }
        
        // Если для адресов список пуст (пользователь не выбрал первый пункт), покажем базовый набор
        let itemsToDisplay = currentItems.isEmpty ? [DropDownItem(title: "Выберите сначала вид отхода", subtitle: "Поле выше не должно быть пустым", iconName: "exclamationmark.circle", iconColor: .systemGray)] : currentItems
        
        // Создаем выпадающее окно, передавая отфильтрованные данные
        let dropDownView = SortingDropDownView(items: itemsToDisplay)
        
        // === ИСПРАВЛЕНИЕ: ВОЗВРАЩАЕМ ПРОПУЩЕННЫЕ СТРОКИ СЮДА ===
        dropDownView.translatesAutoresizingMaskIntoConstraints = false // Разрешаем Auto Layout [1]
        dropDownView.tag = 999
        view.addSubview(dropDownView) // Обязательно добавляем на экран ДО активации констрейнтов [1]
        // ======================================================

        dropDownView.onItemSelected = { [weak self] (selectedItem: DropDownItem) in
            // Защита от выбора заглушки "Выберите сначала вид отхода"
            if selectedItem.iconName == "exclamationmark.circle" { return }
            
            anchorField.text = selectedItem.title
            
            if type == .wasteType {
                self?.setFieldLeftIcon(anchorField, systemName: selectedItem.iconName, color: selectedItem.iconColor)
            } else {
                self?.setFieldLeftIcon(anchorField, systemName: "mappin.and.ellipse", color: .systemGray)
            }
            
            self?.validateFields()           // Активирует и зажигает кнопку заказа
            self?.updateSortingReminder()    // ПРИНУДИТЕЛЬНО выкатывает зеленую плашку подсказки!
            
            self?.removeExistingDropDown()
        }

        anchorField.setRightImage(systemName: "chevron.up", tintColor: .systemGray2)
        
        // Динамический расчет высоты окна: если адресов 2, рамка сожмется под них, а не будет пустой внизу
        let itemHeight: CGFloat = 64
        let padding: CGFloat = 8
        let calculatedHeight = CGFloat(itemsToDisplay.count) * itemHeight + padding
        let finalHeight = min(calculatedHeight, 390) // Ограничиваем максимальный размер до 390 поинтов
        
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
    private func setFieldLeftIcon(_ textField: UITextField, systemName: String, color: UIColor) {
        let iv = UIImageView(image: UIImage(systemName: systemName))
        iv.tintColor = color
        iv.contentMode = .scaleAspectFit
        
        // Увеличили ширину контейнера до 52 (было 40), чтобы отодвинуть текст подальше от иконки
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 52, height: 24))
        iv.frame = CGRect(x: 16, y: 0, width: 24, height: 24)
        container.addSubview(iv)
        
        textField.leftView = container
        textField.leftViewMode = .always
    }
    
    @objc private func closeDropDownByTap(gesture: UITapGestureRecognizer) {
        let touchPoint = gesture.location(in: view)
        if let existingView = view.viewWithTag(999), existingView.frame.contains(touchPoint) {
            return
        }
        removeExistingDropDown()
    }
    
    func removeExistingDropDown() {
        // Возвращаем стрелочки полей в исходное состояние (направлены вниз)
        wasteTypeTextField.setRightImage(systemName: "chevron.down", tintColor: .systemGray2)
        pickupPointTextField.setRightImage(systemName: "chevron.down", tintColor: .systemGray2)
        
        // Удаляем выпадающее окно из памяти с плавной анимацией исчезновения
        if let existingView = view.viewWithTag(999) {
            UIView.animate(withDuration: 0.15, animations: {
                existingView.alpha = 0
            }) { _ in
                existingView.removeFromSuperview()
            }
        }
    }
}
