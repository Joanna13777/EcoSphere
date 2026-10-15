import UIKit

// MARK: - Настройка Экшенов, Навигации и Отправки
extension FeedbackViewController {
    
    func setupNavigationBar() {
        title = "Обратная связь"
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .appText
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func setupActions() {
        categoryTextField.delegate = self
        messageTextView.delegate = self
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        categoryTextField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
        attachFileButton.addTarget(self, action: #selector(attachFileTapped), for: .touchUpInside)

        
        // Настройка живой валидации цветов кнопки "Отправить"
        sendButton.configurationUpdateHandler = { [weak self] btn in
            guard let self = self else { return }
            
            let isTopicFilled = !(self.categoryTextField.text?.isEmpty ?? true)
            let messageText = self.messageTextView.text ?? ""
            let isMessageFilled = !messageText.isEmpty && messageText != "Ваше сообщение..."
            let isFormValid = isTopicFilled && isMessageFilled
            
            btn.isEnabled = isFormValid
            
            var updatedConfig = btn.configuration
            if !btn.isEnabled {
                updatedConfig?.baseBackgroundColor = .systemGray5
                updatedConfig?.baseForegroundColor = .systemGray2
            } else if btn.isHighlighted {
                updatedConfig?.baseBackgroundColor = UIColor.systemGray
                updatedConfig?.baseForegroundColor = .systemBackground
            } else {
                updatedConfig?.baseBackgroundColor = .label
                updatedConfig?.baseForegroundColor = .systemBackground
            }
            btn.configuration = updatedConfig
        }
        
        if #available(iOS 17.0, *) {
            registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (vc: FeedbackViewController, _) in
                vc.messageTextView.layer.borderColor = UIColor.appSeparator.cgColor
            }
        }
    }
    
    //  ВЫПАДАЮЩИЙ СПИСОК СЕРЫХ ТЕМ
    func showCategoryDropDownMenu() {
        let dropDownTable = UITableView(frame: .zero, style: .plain)
        dropDownTable.backgroundColor = .appCardBackground
        dropDownTable.layer.cornerRadius = 12
        dropDownTable.layer.borderWidth = 1
        dropDownTable.layer.borderColor = UIColor.appSeparator.cgColor
        dropDownTable.separatorStyle = .singleLine
        dropDownTable.separatorColor = UIColor.appSeparator
        dropDownTable.showsVerticalScrollIndicator = false
        
        dropDownTable.dataSource = self
        dropDownTable.delegate = self
        dropDownTable.register(UITableViewCell.self, forCellReuseIdentifier: "TopicDropdownCell")
        
        self.categoriesDropDownView = dropDownTable
        
        dropDownTable.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dropDownTable)
        dropDownTable.alpha = 0
        
        // Динамические констрейнты плашки выпадающего списка
        NSLayoutConstraint.activate([
            dropDownTable.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 2),
            dropDownTable.leadingAnchor.constraint(equalTo: categoryTextField.leadingAnchor),
            dropDownTable.trailingAnchor.constraint(equalTo: categoryTextField.trailingAnchor),
            dropDownTable.heightAnchor.constraint(equalToConstant: 220)
        ])
        
        UIView.animate(withDuration: 0.2) {
            dropDownTable.alpha = 1
        }
        
        isDropDownVisible = true
    }

    
    // Вспомогательный метод анимированного скрытия
    func closeDropDownMenuWithAnimation() {
        // Находим добавленную таблицу в сабвью contentView и убираем её
        if let dropDownTable = contentView.subviews.first(where: { $0 is UITableView && $0.alpha == 1 }) {
            UIView.animate(withDuration: 0.15, animations: {
                dropDownTable.alpha = 0
            }) { _ in
                dropDownTable.removeFromSuperview()
            }
        }
        isDropDownVisible = false
        textFieldsChanged() // Обновляем цвет кнопки "Отправить"
    }
    
    @objc func sendTapped() {
        print("🔘 Нажатие на кнопку 'Отправить' зафиксировано системой!")
        view.endEditing(true)
        
        let topic = categoryTextField.text ?? ""
        let message = messageTextView.text ?? ""
        
        if topic.isEmpty || message.isEmpty || message == "Ваше сообщение..." {
            let alert = UIAlertController(title: "Внимание", message: "Пожалуйста, выберите тему и напишите текст вашего обращения.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default))
            self.present(alert, animated: true)
            return
        }
        
        let botToken = "8858495099:AAH_Rj7XKCQYmZGNueken7eQA6ni26AvHQQ"
        let chatId = "-1004453945133"
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.telegram.org"
        components.path = "/bot\(botToken)/sendMessage"
        
        guard let url = components.url else { return }
        
        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "user_profile_name") ?? "Гость"
        let userPhone = defaults.string(forKey: "user_profile_phone") ?? "Номер не указан"
        
        let telegramText = """
        📬 *Новое обращение в поддержку!*
        
        👤 *Пользователь:* \(userName)
        📞 *Телефон:* \(userPhone)
        📌 *Тема:* \(topic)
        
        💬 *Сообщение:*
        \(message)
        """
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonParameters: [String: Any] = [
            "chat_id": chatId,
            "text": telegramText,
            "parse_mode": "Markdown"
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: jsonParameters, options: []) else { return }
        request.httpBody = httpBody
        
        sendButton.alpha = 0.4
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.sendButton.alpha = 1.0
                
                if let error = error {
                    self.showResultAlert(title: "Ошибка сети", message: error.localizedDescription)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        SupportChatManager.shared.addNewRequest(category: topic, message: message, attachmentData: self.selectedImageData)
                        
                        self.messageTextView.text = "Ваше сообщение..."
                        self.messageTextView.textColor = .placeholderText
                        self.textFieldsChanged()
                        
                        self.showResultAlert(title: "Успешно", message: "Ваше обращение доставлено техподдержке!") {
                            self.navigationController?.popViewController(animated: true)
                        }
                    } else {
                        self.showResultAlert(title: "Ошибка отправки", message: "Сервер вернул код: \(httpResponse.statusCode).")
                    }
                }
            }
        }.resume()
    }
    
    @objc func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textFieldsChanged() {
        sendButton.setNeedsUpdateConfiguration()
    }
    
    func showResultAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true)
    }
}

extension FeedbackViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func attachFileTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            // Сжимаем картинку в Data для хранения в UserDefaults
            self.selectedImageData = pickedImage.jpegData(compressionQuality: 0.7)
            
            // Показываем мини-превью на экране
            self.previewImageView.image = pickedImage
            self.previewImageView.isHidden = false
            
            // Меняем текст на кнопке
            self.attachFileButton.setTitle("Изменить фото", for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
