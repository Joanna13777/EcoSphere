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
        
        let opacityGrayColor = UIColor(red: 0.35, green: 0.35, blue: 0.35, alpha: 1.0)
        
        let wasteItems = [
            DropDownItem(title: "Макулатура (бумага)", subtitle: "картон, втулки, яичные кассеты, книги, тетради, газеты", iconName: "doc.text.fill", iconColor: .systemBlue),
            DropDownItem(title: "Стекло", subtitle: "бутылки, банки для консервации, флаконы от духов", iconName: "wineglass.fill", iconColor: .systemGreen),
            DropDownItem(title: "Пластик", subtitle: "бутылки, крышки, банки, пакеты, посуда, контейнеры", iconName: "capsule.fill", iconColor: UIColor(red: 0.96, green: 0.71, blue: 0.10, alpha: 1.0)),
            DropDownItem(title: "Металл", subtitle: "консервные банки, гвозди, проволока, мет. лом", iconName: "hammer.fill", iconColor: .systemPurple),
            DropDownItem(title: "Органические отходы", subtitle: "Пищевые отходы", iconName: "leaf.fill", iconColor: opacityGrayColor),
            DropDownItem(title: "Пункты приёма металла", subtitle: "Сломанные телефоны, бытовая техника, провода", iconName: "tv.fill", iconColor: .systemGray)
        ]
        
        let addressItems = [
            DropDownItem(title: "ул. Амира Темура, 14", subtitle: "Пункт сбора пластика и макулатуры", iconName: "mappin.and.ellipse", iconColor: .darkGray),
            DropDownItem(title: "ул. Нукусская, 44", subtitle: "Пункт приема электронных отходов", iconName: "mappin.and.ellipse", iconColor: .darkGray),
            DropDownItem(title: "проспект Навои, 89", subtitle: "Центральный хаб сортировки сырья", iconName: "mappin.and.ellipse", iconColor: .darkGray)
        ]
        
        let currentItems = type == .wasteType ? wasteItems : addressItems
        
        let dropDownView = SortingDropDownView(items: currentItems)
        dropDownView.translatesAutoresizingMaskIntoConstraints = false
        dropDownView.tag = 999
        
        view.addSubview(dropDownView)
        
        dropDownView.onItemSelected = { [weak self] (selectedItem: DropDownItem) in
            anchorField.text = selectedItem.title
            
            if type == .wasteType {
                // Вставляем цветную иконку сырья и делаем красивый отступ
                self?.setFieldLeftIcon(anchorField, systemName: selectedItem.iconName, color: selectedItem.iconColor)
            } else {
                // ПУНКТ 2: При выборе адреса вставляем иконку локации перед текстом
                self?.setFieldLeftIcon(anchorField, systemName: "mappin.and.ellipse", color: .systemGray)
            }
            
            self?.removeExistingDropDown()
        }
        
        anchorField.setRightImage(systemName: "chevron.up", tintColor: .systemGray2)
        
        let dynamicHeight: CGFloat = type == .wasteType ? 390 : 200
        
        NSLayoutConstraint.activate([
            dropDownView.topAnchor.constraint(equalTo: anchorField.bottomAnchor, constant: 4),
            dropDownView.leadingAnchor.constraint(equalTo: anchorField.leadingAnchor),
            dropDownView.trailingAnchor.constraint(equalTo: anchorField.trailingAnchor),
            dropDownView.heightAnchor.constraint(equalToConstant: dynamicHeight)
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
