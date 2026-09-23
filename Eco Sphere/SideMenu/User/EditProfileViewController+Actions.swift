// вся активная логика: нажатия кнопок,

import UIKit
import MapKit

// MARK: - Настройка связей, Экшенов и Навигации
extension EditProfileViewController {
    
    func setupNavigationBar() {
        title = "Профиль"
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .appText
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func setupDelegatesAndActions() {
        phoneTextField.delegate = self
        emailTextField.delegate = self
        cityTextField.delegate = self
        
        changeAvatarButton.addTarget(self, action: #selector(selectPhotoTapped), for: .touchUpInside)
        let avatarTap = UITapGestureRecognizer(target: self, action: #selector(selectPhotoTapped))
        avatarImageView.addGestureRecognizer(avatarTap)
        
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        if let mapButton = addressTextField.rightView as? UIButton {
            mapButton.addTarget(self, action: #selector(openMapTapped), for: .touchUpInside)
        }
    }
    
    func setupKeyboardInteractions() {
        let fields: [UIResponder] = [nameTextField, surnameTextField, addressTextField, phoneTextField, emailTextField]
        fields.forEach { $0.addDoneButtonOnKeyboard() }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAndDropDown))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveTapped() {
        // 1. Извлекаем текущий текст из всех полей ввода
        let name = nameTextField.text ?? ""
        let surname = surnameTextField.text ?? ""
        let city = cityTextField.text ?? ""
        let address = addressTextField.text ?? ""
        let phone = phoneTextField.text ?? ""
        let email = emailTextField.text ?? ""
        
        // 2. АВТО-ОЧИСТКА: Удаляем слово "Ташкент" (и сокращения вроде "г.") перед записью в память
        let pattern = "(?i)(г\\.?\\s*)?ташкент\\s*,?\\s*"
        var finalSaveAddress = address.replacingOccurrences(of: pattern, with: "", options: .regularExpression)
        
        // Стираем случайные пробелы и запятые по краям строки
        finalSaveAddress = finalSaveAddress.trimmingCharacters(in: .whitespacesAndNewlines)
        if finalSaveAddress.hasPrefix(",") { finalSaveAddress.removeFirst() }
        finalSaveAddress = finalSaveAddress.trimmingCharacters(in: .whitespacesAndNewlines)

        // 3. Записываем гарантированно очищенные данные в локальную память приложения
        let defaults = UserDefaults.standard
        defaults.set("\(name) \(surname)".trimmingCharacters(in: .whitespacesAndNewlines), forKey: "user_profile_name")
        defaults.set(phone, forKey: "user_profile_phone")
        defaults.set(city, forKey: "user_profile_city")
        
        // Важно: Сохраняем только чистую улицу и номер дома, без дублирования города
        defaults.set(finalSaveAddress, forKey: "user_profile_address")
        defaults.set(email, forKey: "user_profile_email")
        
        // 4. Сохраняем аватарку пользователя, если она была изменена
        if let avatarImage = avatarImageView.image {
            if let jpegData = avatarImage.jpegData(compressionQuality: 0.8) {
                defaults.set(jpegData, forKey: "user_profile_avatar_data")
            }
        }
        
        // 5. Посылаем сигнал экрану Меню через делегат для мгновенного обновления верхней шапки
        delegate?.didUpdateProfileData()
        
        // 6. Плавно закрываем экран Профиля и возвращаемся назад в Меню
        navigationController?.popViewController(animated: true)
    }


}

// MARK: - Работа с Фото (Камера и Галерея)
extension EditProfileViewController: UIImagePickerControllerDelegate {
    
    @objc func selectPhotoTapped() {
        dismissKeyboardAndDropDown()
        let alert = UIAlertController(title: "Фото профиля", message: "Выберите действие", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Галерея", style: .default, handler: { _ in
            self.presentImagePicker(source: .photoLibrary)
        }))
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Камера", style: .default, handler: { _ in
                self.presentImagePicker(source: .camera)
            }))
        }
        
        let isDefaultAvatar = avatarImageView.image == UIImage(systemName: "person.crop.circle.fill")
        if !isDefaultAvatar {
            alert.addAction(UIAlertAction(title: "Удалить фото", style: .destructive, handler: { _ in
                self.avatarImageView.image = UIImage(systemName: "person.crop.circle.fill")
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func presentImagePicker(source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = source
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            avatarImageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            avatarImageView.image = originalImage
        }
        picker.dismiss(animated: true)
    }
}

// MARK: - Управление Выпадающим Окном Городов
extension EditProfileViewController {
    
    func toggleCitiesDropDown() {
        if isDropDownVisible { hideCitiesDropDown() } else { showCitiesDropDown() }
    }
    
    func showCitiesDropDown() {
        guard citiesDropDownView == nil else { return }
        view.endEditing(true)
        
        let tashkentItem = DropDownItem(title: "Ташкент", subtitle: "Узбекистан", iconName: "building.2.crop.left", iconColor: .appAccent)
        let dropDown = SortingDropDownView(items: [tashkentItem])
        dropDown.translatesAutoresizingMaskIntoConstraints = false
        dropDown.alpha = 0.0
        
        contentView.addSubview(dropDown)
        self.citiesDropDownView = dropDown
        
        NSLayoutConstraint.activate([
            dropDown.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 4),
            dropDown.leadingAnchor.constraint(equalTo: cityTextField.leadingAnchor),
            dropDown.trailingAnchor.constraint(equalTo: cityTextField.trailingAnchor),
            dropDown.heightAnchor.constraint(equalToConstant: 66) // Жесткое валидное число без вычислений
        ])

        
        dropDown.onItemSelected = { [weak self] item in
            self?.cityTextField.text = item.title
            self?.hideCitiesDropDown()
        }
        
        UIView.animate(withDuration: 0.25) {
            dropDown.alpha = 1.0
            self.isDropDownVisible = true
        }
    }
    
    func hideCitiesDropDown() {
        guard let dropDown = citiesDropDownView else { return }
        UIView.animate(withDuration: 0.2, animations: {
            dropDown.alpha = 0.0
        }) { _ in
            dropDown.removeFromSuperview()
            self.citiesDropDownView = nil
            self.isDropDownVisible = false
        }
    }
    
    @objc func dismissKeyboardAndDropDown() {
        view.endEditing(true)
        hideCitiesDropDown()
    }
    
    @objc func openMapTapped() {
        dismissKeyboardAndDropDown()
        let tashkentCenter = CLLocationCoordinate2D(latitude: 41.311081, longitude: 69.240562)
        let region = MKCoordinateRegion(center: tashkentCenter, latitudinalMeters: 12000, longitudinalMeters: 12000)
        
        let fullMapVC = FullMapViewController(initialRegion: region)
                
        fullMapVC.onAddressSelected = { [weak self] selectedAddress in
            // ГЛАВНОЕ ИСПРАВЛЕНИЕ: Переносим обработку UI строго в главный поток
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                let pattern = "(?i)(г(ород)?\\.?\\s*)?ташкент\\s*,?\\s*"
                let countryPattern = "(?i)узбекистан\\s*,?\\s*"
                
                var cleanAddress = selectedAddress.replacingOccurrences(
                    of: pattern,
                    with: "",
                    options: .regularExpression
                )
                
                cleanAddress = cleanAddress.replacingOccurrences(
                    of: countryPattern,
                    with: "",
                    options: .regularExpression
                )
                
                var finalAddress = cleanAddress.trimmingCharacters(in: .whitespacesAndNewlines)
                if finalAddress.hasPrefix(",") { finalAddress.removeFirst() }
                finalAddress = finalAddress.trimmingCharacters(in: .whitespacesAndNewlines)
                
                if finalAddress.lowercased().hasPrefix("ул. ул. ") {
                    finalAddress = finalAddress.replacingOccurrences(of: "ул. ул. ", with: "ул. ")
                }
                
                // 1. Записываем чистый адрес в текстовое поле Профиля
                self.addressTextField.text = finalAddress
                
                // 2. ИСПРАВЛЕНО: Закрываем модальный UINavigationController, так как он открывался через present
                self.presentedViewController?.dismiss(animated: true, completion: nil)
                
                print("🗺️ Адрес успешно возвращен в профиль: \(finalAddress)")
            }
        }

        let navController = UINavigationController(rootViewController: fullMapVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }


}

// MARK: - Валидация Текстовых Полей (Ваш Делегат)
extension EditProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == cityTextField {
            toggleCitiesDropDown()
            return false
        }
        hideCitiesDropDown()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return true }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if textField == phoneTextField {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            if !allowedCharacters.isSuperset(of: characterSet) && string != "" { return false }
            
            if currentText.isEmpty && !string.isEmpty {
                textField.text = "+" + string
                return false
            }
            if updatedText.isEmpty || !updatedText.hasPrefix("+") {
                textField.text = "+"
                return false
            }
            return true
        }
        
        if textField == emailTextField {
            if string.isEmpty { return true }
            let englishAndSymbols = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@._-")
            let characterSet = CharacterSet(charactersIn: string)
            
            if !englishAndSymbols.isSuperset(of: characterSet) {
                let alert = UIAlertController(title: "Раскладка клавиатуры", message: "Пожалуйста, переключитесь на английский язык для ввода почты.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Хорошо", style: .default, handler: nil))
                self.present(alert, animated: true)
                return false
            }
            return true
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == phoneTextField && (textField.text?.isEmpty ?? true) {
            textField.text = "+"
        }
    }
}

// MARK: - Автоподъем экрана при вызове клавиатуры
extension EditProfileViewController {
    
    @objc func keyboardWillShow(notification: NSNotification) {
        // ИСПРАВЛЕНО: на экране профиля вызываем скрытие городов, а не категорий
        hideCitiesDropDown()
        
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        // 1. Обновляем инсеты скролла
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight + 20, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        // 2. БЕЗОПАСНЫЙ АВТОПОДЪЕМ: Находим активное текстовое поле профиля
        let allFields = [nameTextField, surnameTextField, cityTextField, addressTextField, phoneTextField, emailTextField]
        if let activeField = allFields.first(where: { $0.isFirstResponder }) {
            
            let rect = contentView.convert(activeField.frame, to: scrollView)
            
            // Проверяем фрейм активного поля на NaN перед скроллом
            let isRectValid = !rect.origin.x.isNaN && !rect.origin.x.isInfinite &&
                              !rect.origin.y.isNaN && !rect.origin.y.isInfinite &&
                              !rect.size.width.isNaN && !rect.size.width.isInfinite &&
                              !rect.size.height.isNaN && !rect.size.height.isInfinite
            
            if isRectValid {
                scrollView.scrollRectToVisible(rect, animated: true)
            } else {
                print("⚠️ Предотвращен сбой CoreGraphics в Профиле: rect содержал NaN координаты.")
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        // При закрытии клавиатуры мягко возвращаем форму в исходное положение
        let contentInsets = UIEdgeInsets.zero
        UIView.animate(withDuration: 0.25) {
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }
    }
}

