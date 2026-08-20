import UIKit

// MARK: - Действия, Делегаты и Интерактивная Логика Полей
extension PickupViewController: UITextFieldDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
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
    
    @objc private func wasteTypeFieldTapped() {
        showCustomDropDown(anchorField: wasteTypeTextField, type: PickupViewController.DropDownType.wasteType)
        
        // Искусственный пинг через 0.15 секунды, когда таблица дропдауна уже отдала текст полю
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            self?.validateFields()
            self?.updateSortingReminder()
        }
    }


    @objc private func pickupPointFieldTapped() {
        showCustomDropDown(anchorField: pickupPointTextField, type: PickupViewController.DropDownType.pickupPoint)
        
        // Запускаем небольшую задержку для адреса
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.validateFields()
        }
    }

    
    // --- ИНТЕЛЛЕКТУАЛЬНЫЙ МАСОЧНЫЙ ВВОД ВЕСА ("... кг") ---
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Внутри метода textField(shouldChangeCharactersIn...) замените обработку веса:
        
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
        
        if textField == wasteTypeTextField || textField == pickupPointTextField {
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
            self?.showSuccessAlert()
        }
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }
    
    private func showSuccessAlert() {
        let selectedWaste = wasteTypeTextField.text ?? "Вторсырье"
        let selectedAddress = pickupPointTextField.text ?? "Адрес не указан"
        let selectedWeight = weightTextField.text?.isEmpty ?? true ? "0 кг" : (weightTextField.text ?? "0 кг")
        
        // Формируем красивую дату из встроенного календаря для экрана истории
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "d MMMM, HH:mm"
        let fullDateString = formatter.string(from: inlineDatePicker.date)
        
        let newOrder = HistoryOrder(
            wasteType: selectedWaste,
            iconName: "clock.arrow.circlepath",
            iconColor: .systemGray,
            date: fullDateString,
            weight: selectedWeight,
            address: selectedAddress,
            status: "В обработке",
            isCompleted: false
        )
        
        OrderManager.shared.addNewOrder(newOrder)
        
        let successAlert = UIAlertController(
            title: "Заказ принят  \u{2705}",
            message: "\nОтследить данные можно\nв \"Истории вывозов\"",
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
        let isWasteTypeFilled = !(wasteTypeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        let isPickupPointFilled = !(pickupPointTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        let isWeightFilled = !(weightTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        
        let isFormValid: Bool
        
        if isLoggedIn {
            // Если пользователь авторизован — проверяем только эти 3 поля
            isFormValid = isWasteTypeFilled && isPickupPointFilled && isWeightFilled
        } else {
            // Если НЕ авторизован — проверяем еще имя, телефон и адрес
            let isNameFilled = !(nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
            let isPhoneFilled = !(phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
            let isAddressFilled = !(addressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
            
            isFormValid = isWasteTypeFilled && isPickupPointFilled && isWeightFilled &&
                          isNameFilled && isPhoneFilled && isAddressFilled
        }
        
        // Включаем или выключаем кнопку заказа
        orderButton.isEnabled = isFormValid
    }

}
