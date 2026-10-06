import UIKit

// MARK: - Действия, Делегаты и Интерактивная Логика Полей
extension PickupViewController: UITextFieldDelegate {
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setupDelegates() {
        descriptionTextView.delegate = self
        phoneTextField.delegate = self
        weightTextField.delegate = self
        
        wasteTypeTextField.delegate = self
        pickupPointTextField.delegate = self
    }
    
    func setupActions() {
        orderButton.addTarget(self, action: #selector(orderTapped), for: .touchUpInside)
        
        wasteTypeTextField.addTarget(self, action: #selector(wasteTypeFieldTapped), for: .editingDidBegin)
        pickupPointTextField.addTarget(self, action: #selector(pickupPointFieldTapped), for: .editingDidBegin)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        validateFields() // Проверяем поля при закрытии клавиатуры или дропдауна
        updateSortingReminder()
    }
    
    @objc func pickupAddressFieldTapped() {
        // 1. Сразу закрываем клавиатуру
        view.endEditing(true)
        
        // 2. Читаем массив строк из памяти симулятора напрямую
        let savedAddresses = UserDefaults.standard.stringArray(forKey: "user_favorite_addresses") ?? []
        
        let addressItems: [DropDownItem]
        
        if savedAddresses.isEmpty {
            // Если гость ещё не заходил в Избранное, выводим красивую подсказку-заглушку
            addressItems = [DropDownItem(
                title: "Добавить адрес в профиле",
                subtitle: "У вас пока нет сохраненных адресов",
                iconName: "mappin.and.ellipse",
                iconColor: .systemGray
            )]
        } else {
            // Преобразуем строки сохраненных адресов в элементы выпадающей таблицы со значком домика
            addressItems = savedAddresses.map { addressText in
                return DropDownItem(
                    title: addressText,
                    subtitle: "Ваш избранный адрес",
                    iconName: "house.fill", // Нативная иконка домика
                    iconColor: .systemGreen // Наш красивый эко-зеленый цвет
                )
            }
        }
        
        // 3. Создаем выпадающее окно, передавая готовые данные адресов
        let dropDownView = SortingDropDownView(items: addressItems)
        dropDownView.translatesAutoresizingMaskIntoConstraints = false
        dropDownView.tag = 999
        
        // Удаляем старое окно, если оно уже было открыто на экране
        removeExistingDropDown()
        
        // Добавляем новое окно строго внутрь contentView
        contentView.addSubview(dropDownView)
        
        // Настраиваем логику выбора элемента
        dropDownView.onItemSelected = { [weak self] (selectedItem: DropDownItem) in
            if selectedItem.title == "Добавить адрес в профиле" { return }
            
            // Подставляем выбранную улицу в текстовое поле адреса вывоза
            self?.pickupAddressTextField.text = selectedItem.title
            
            // Ставим красивую левую эко-иконку домика в поле ввода
            if let field = self?.pickupAddressTextField {
                self?.setFieldLeftIcon(field, systemName: "house.fill", color: .systemGreen)
            }
            
            self?.validateFields()           // Проверяем активность кнопки заказа
            self?.removeExistingDropDown()  // Закрываем окно
        }
        
        // Меняем стрелочку поля на "вверх" при открытии списка
        pickupAddressTextField.setRightImage(systemName: "chevron.up", tintColor: .systemGray2)
        
        // Динамический расчет высоты окна под количество адресов
        let itemHeight: CGFloat = 64
        let padding: CGFloat = 8
        let calculatedHeight = CGFloat(addressItems.count) * itemHeight + padding
        let finalHeight = min(calculatedHeight, 250) // Ограничиваем максимальный размер
        
        // Активируем констрейнты выпадающего списка под полем "Адрес вывоза"
        NSLayoutConstraint.activate([
            dropDownView.topAnchor.constraint(equalTo: pickupAddressTextField.bottomAnchor, constant: 4),
            dropDownView.leadingAnchor.constraint(equalTo: pickupAddressTextField.leadingAnchor),
            dropDownView.trailingAnchor.constraint(equalTo: pickupAddressTextField.trailingAnchor),
            dropDownView.heightAnchor.constraint(equalToConstant: finalHeight)
        ])
        
        // Добавляем жест закрытия по тапу мимо окна
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(closeDropDownByTap))
        closeTap.cancelsTouchesInView = false
        view.addGestureRecognizer(closeTap)
    }

    // MARK: - Вызов списков (Устраняет оставшиеся 4 ошибки)
    
    @objc func wasteTypeFieldTapped() {
        view.endEditing(true)
        showCustomDropDown(anchorField: wasteTypeTextField, type: PickupViewController.DropDownType.wasteType)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            self?.validateFields()
            self?.updateSortingReminder()
        }
    }

    @objc func pickupPointFieldTapped() {
        view.endEditing(true)
        showCustomDropDown(anchorField: pickupPointTextField, type: PickupViewController.DropDownType.pickupPoint)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.validateFields()
        }
    }

    @objc func pickupAddressChanged(_ textField: UITextField) {
        // Если пользователь начал писать руками — ставим нейтральную серую гео-метку
        setFieldLeftIcon(textField, systemName: "mappin.and.ellipse", color: .systemGray2)
        self.validateFields()
    }
    
    // --- ИНТЕЛЛЕКТУАЛЬНЫЙ МАСОЧНЫЙ ВВОД ВЕСА ("... кг") ---
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // обработкa веса:
        
        if string.isEmpty {
            if textField == weightTextField {
                let currentText = textField.text ?? ""
                let cleanText = currentText.replacingOccurrences(of: " кг", with: "").replacingOccurrences(of: " ", with: "")
                if cleanText.isEmpty { return false }
                let updatedText = String(cleanText.dropLast())
                
                if updatedText.isEmpty {
                    textField.text = ""
                } else {
                    textField.text = "\(updatedText) кг"
                }
                
                validateFields()
                return false
            }
            return true
        }
        
        // Запрещаем ручной ввод букв и в поле адреса вывоза
        if textField == wasteTypeTextField || textField == pickupPointTextField || textField == pickupAddressTextField {
            return false
        }

        
        if textField == weightTextField {
            let currentText = textField.text ?? ""
            // Очищаем текст от маски, оставляя цифры, точки и запятые
            let cleanText = currentText.replacingOccurrences(of: " кг", with: "").replacingOccurrences(of: " ", with: "")
            
            // Автоматически заменяем точку на запятую для единообразия интерфейса
            let processedString = string.replacingOccurrences(of: ".", with: ",")
            
            // Разрешаем вводить только цифры и ОДНУ запятую
            let allowedCharacters = CharacterSet(charactersIn: "0123456789,")
            guard processedString.allSatisfy({ $0.unicodeScalars.allSatisfy(allowedCharacters.contains) }) else { return false }
            
            // Если запятая уже есть, вторую ввести не даем
            if processedString == "," && cleanText.contains(",") { return false }
            
            // Ограничиваем длину ввода до 5 символов (например, "104,5")
            guard cleanText.count + processedString.count <= 5 else { return false }
            
            let newText = cleanText + processedString
            textField.text = "\(newText) кг"
            
            validateFields()
            return false
        }

        
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == phoneTextField && (textField.text?.isEmpty ?? true) {
            textField.text = "+"
        }
    }
    
    // Срабатывает автоматически, когда фокус уходит из любого текстового поля или дропдауна
    public func textFieldDidEndEditing(_ textField: UITextField) {
        validateFields() // Проверяет активность кнопки
        
        // Если пользователь закончил выбирать вид отхода — обновляем карточку!
        if textField == wasteTypeTextField {
            updateSortingReminder()
        }
    }

    
    // --- ОФОРМЛЕНИЕ ЗАКАЗА ДЛЯ ОБЩЕЙ МОДЕЛИ MODEL.SWIFT ---
    @objc func orderTapped() {
        view.endEditing(true)
        
        let alert = UIAlertController(title: "Заказать вывоз вторсырья?", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отменить", style: .default, handler: nil)
        let confirmAction = UIAlertAction(title: "Заказать", style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            // 1. Извлекаем текст из заполненных полей
            let wasteType = self.wasteTypeTextField.text ?? "Не указан"
            let pickupAddress = self.pickupAddressTextField.text ?? "Не указан"
            let weight = self.weightTextField.text ?? "0 кг"
            
            // 2. Пытаемся взять иконку и её цвет прямо из левого view поля ввода мусора
            // (Если там ничего нет, ставим стандартную иконку коробки)
            var wasteIconName = "shippingbox.fill"
            var wasteIconColor = UIColor.systemGreen
            
            if let leftView = self.wasteTypeTextField.leftView,
               let imageView = leftView.subviews.first(where: { $0 is UIImageView }) as? UIImageView {
                wasteIconName = self.pickupModelManagerWasteIconName(for: wasteType) // Или если в DropDownItem была иконка, используем её
                wasteIconColor = imageView.tintColor ?? .systemGreen
            }
            
            // Форматируем текущую дату красиво
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.dateFormat = "d MMMM, HH:mm"
            let currentDateString = formatter.string(from: Date())
            
            // 3. Создаем красивую структурированную модель HistoryOrder
            let newOrder = HistoryOrder(
                id: UUID(),
                wasteType: wasteType,
                iconName: wasteIconName,
                iconColorHex: wasteIconColor.toHexString,
                date: currentDateString,
                weight: weight.contains("кг") ? weight : "\(weight) кг",
                address: pickupAddress,
                status: "В обработке",
                isCompleted: false
            )
            
            // 4. Отправляем заказ в наш глобальный менеджер истории!
            OrderManager.shared.addNewOrder(newOrder)
            print("✅ Заказ успешно добавлен в OrderManager.shared")
            
            // 5. Показываем зеленый экран успеха
            self.showSuccessAlert()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }

    // Вспомогательный метод для точного определения имени SF Symbols по названию вторсырья
    private func pickupModelManagerWasteIconName(for wasteType: String) -> String {
        // Переводим текст в нижний регистр, чтобы проверка работала независимо от больших/маленьких букв
        let type = wasteType.lowercased()
        
        if type.contains("бумага") || type.contains("макулатура") {
            return "doc.text.fill" // Иконка документа/бумаги
        }
        if type.contains("стекло") {
            return "wineglass.fill" // Иконка бокала/стекла
        }
        if type.contains("пластик") {
            return "takeoutbag.and.cup.and.straw.fill" // Плотная иконка капсулы (идеально смотрится как бутылка/пластик)
        }
        if type.contains("металл") {
            return "wrench.adjustable.fill" // Системная иконка металлической гайки (работает для металла)
        }
        if type.contains("Органика") {
            return "leaf.fill" // иконка лист, Органические отходы
        }
        if type.contains("Электро") {
            return "tv.fill" // иконка лист, Органические отходы
        }
        // Если вид отхода редкий или не совпал — возвращаем универсальную коробку
        return "shippingbox.fill"
    }

    private func showSuccessAlert() {
        let selectedWaste = wasteTypeTextField.text ?? "Вторсырье"
        // Берём адрес из нового поля адреса вывоза
        let selectedAddress = pickupAddressTextField.text?.isEmpty ?? true ? (pickupPointTextField.text ?? "Адрес не указан") : (pickupAddressTextField.text ?? "")

        let selectedWeight = weightTextField.text?.isEmpty ?? true ? "0 кг" : (weightTextField.text ?? "0 кг")
        
        // Формируем красивую дату из встроенного календаря для экрана истории
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM, HH:mm"
        let fullDateString = formatter.string(from: inlineDatePicker.date)
        
        let alertMessage = """
            
            Вид: \(selectedWaste)
            Вес: \(selectedWeight)
            Дата: \(fullDateString)
            Адрес: \(selectedAddress)
            
            Отследить данные можно
            в "Истории вывозов"
            """
        
        let successAlert = UIAlertController(
            title: "Заказ принят  \u{2705}",
            message: alertMessage,
            preferredStyle: .alert
        )
        successAlert.addAction(UIAlertAction(title: "ОК", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(successAlert, animated: true)
    }
}

// MARK: - UITextViewDelegate
extension PickupViewController: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Добавить описание" {
            textView.text = ""
            textView.textColor = .black
        }
    }
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Добавить описание"
            textView.textColor = .lightGray
        }
    }
    
    
    
    var sortingReminders: [String: String] {
        return [
            "Макулатура (бумага)": "Сдавайте картон и бумагу сухими. Удалите скотч, скрепки и металлические пружины перед сдачей.",
            "Стекло": "Принимаются чистые банки и бутылки. Снимите крышки и пробки. Битое стекло сложите в отдельную коробку.",
            "Пластик": "Обязательно сполосните бутылки от остатков пищи и обожмите их, чтобы они занимали меньше места.",
            "Металл": "Промойте консервные банки. По возможности удалите бумажные этикетки и сдавите банки для компактности.",
            "Органические отходы": "Убедитесь, что отходы не содержат пластиковой упаковки, пленок и пакетов. Только органика для компоста.",
            "Электро": "Убедитесь, что из устройств извлечены съемные батарейки и аккумуляторы — их нужно сдавать отдельно."
        ]
    }
    
    func updateSortingReminder() {
        let selectedWaste = wasteTypeTextField.text ?? ""
        
        if let reminderText = sortingReminders[selectedWaste] {
            reminderTextLabel.text = reminderText
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.sortingReminderView.alpha = 1.0
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            reminderTextLabel.text = ""
            UIView.animate(withDuration: 0.2, animations: {
                self.sortingReminderView.alpha = 0.0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func validateFields() {
        // Проверяем базовые поля, которые нужны всем
        let isWasteTypeFilled = !(wasteTypeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        let isPickupPointFilled = !(pickupPointTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        let isWeightFilled = !(weightTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        let isPickupAddressFilled = !(pickupAddressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        
        let isFormValid: Bool
        
        // Проверяем валидность формы в зависимости от статуса авторизации
        if isLoggedIn {
            // Если пользователь авторизован — проверяем основные поля заказа (включая адрес вывоза)
            isFormValid = isWasteTypeFilled && isPickupPointFilled && isWeightFilled && isPickupAddressFilled
        } else {
            // Если НЕ авторизован — проверяем еще имя, телефон и гостевой адрес
            let isNameFilled = !(nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
            let isPhoneFilled = !(phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
            let isAddressFilled = !(addressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
            
            isFormValid = isWasteTypeFilled && isPickupPointFilled && isWeightFilled &&
            isNameFilled && isPhoneFilled && isAddressFilled
        }
        
        // Включаем или выключаем кнопку заказа (ВЫНЕСЕНО ИЗ БЛОКОВ, СРАБАТЫВАЕТ ВСЕГДА)
        orderButton.isEnabled = isFormValid
        
        let favoriteYellowColor = UIColor(red: 251/255, green: 192/255, blue: 45/255, alpha: 1.0)
        
        // Получаем текущую конфигурацию кнопки
        var config = orderButton.configuration ?? UIButton.Configuration.filled()
        
        if isFormValid {
            config.baseBackgroundColor = favoriteYellowColor // Красим в фирменный желтый
            orderButton.tintColor = .black // Делаем текст и иконку грузовика внутри кнопки черными/темными для хорошей читаемости на желтом фоне
            orderButton.alpha = 1.0
        } else {
            config.baseBackgroundColor = .systemGray4 // В неактивном состоянии кнопка остается серой
            orderButton.tintColor = .systemGray       // Серый текст для неактивной кнопки
            orderButton.alpha = 0.6
        }
        
        // Настраиваем скругление углов прямо внутри конфигурации (радиус 12, как у ваших полей ввода)
        config.background.cornerRadius = 12
        
        // Применяем обновленную конфигурацию обратно к кнопке
        orderButton.configuration = config
        
        // Дополнительная защита скругления на уровне слоя кнопки
        orderButton.layer.cornerRadius = 12
        orderButton.clipsToBounds = true
        
    }
}
