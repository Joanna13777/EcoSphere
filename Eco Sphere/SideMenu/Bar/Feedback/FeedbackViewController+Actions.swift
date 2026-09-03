// экшены нажатия кнопок, навигация и сам асинхронный сетевой запрос отправки в Telegram.

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
        
        // ГЛАВНОЕ ИСПРАВЛЕНИЕ: Кнопка настраивает свои цвета напрямую через self
        sendButton.configurationUpdateHandler = { [weak self] btn in
            guard let self = self else { return }
            
            // Напрямую и безопасно проверяем текст в полей нашего контроллера
            let isTopicFilled = !(self.categoryTextField.text?.isEmpty ?? true)
            let messageText = self.messageTextView.text ?? ""
            let isMessageFilled = !messageText.isEmpty && messageText != "Ваше сообщение..."
            let isFormValid = isTopicFilled && isMessageFilled
            
            // Меняем доступность кнопки
            btn.isEnabled = isFormValid
            
            var updatedConfig = btn.configuration
            if !btn.isEnabled {
                // Светло-серая кнопка, если поля пустые
                updatedConfig?.baseBackgroundColor = .systemGray5
                updatedConfig?.baseForegroundColor = .systemGray2
            } else if btn.isHighlighted {
                // Затемнение при нажатии
                updatedConfig?.baseBackgroundColor = UIColor.systemGray
                updatedConfig?.baseForegroundColor = .systemBackground
            } else {
                // Темно-серая/черная кнопка, когда все заполнено
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

    
    @objc func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func sendTapped() {
        print("🔘 Нажатие на кнопку 'Отправить' зафиксировано системой!")
        
        dismissKeyboardAndDropDown()
        
        let topic = categoryTextField.text ?? ""
        let message = messageTextView.text ?? ""
        
        print("📝 Текущие данные полей -> Тема: '\(topic)', Сообщение: '\(message)'")
        
        if topic.isEmpty || message.isEmpty || message == "Ваше сообщение..." {
            print("⚠️ Валидация не прошла! Поля пустые или содержат плейсхолдер.")
            let alert = UIAlertController(title: "Внимание", message: "Пожалуйста, выберите тему и напишите текст вашего обращения.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default))
            self.present(alert, animated: true)
            return
        }
        
        print("🚀 Валидация успешна! Собираем URL через системные компоненты Apple...")
        
        // ЧИСТЫЕ ДАННЫЕ TELEGRAM (БЕЗ СЛЭШЕЙ ИЛИ СИМВОЛОВ СВЯЗИ)
        let botToken = "8858495099:AAH_Rj7XKCQYmZGNueken7eQA6ni26AvHQQ"
        let chatId = "-1004453945133"
        
        // БЕЗОПАСНАЯ СБОРКА ИНТЕРНЕТ-АДРЕСА ЧЕРЕЗ URLComponents
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.telegram.org"
        components.path = "/bot\(botToken)/sendMessage" // Системный конструктор сам расставит правильные слэши
        
        guard let url = components.url else {
            print("❌ КРИТИЧЕСКАЯ ОШИБКА: URLComponents не смогли собрать адрес. Проверьте токен!")
            return
        }
        
        print("🔗 СФОРМИРОВАН ИДЕАЛЬНЫЙ СЕТЕВОЙ АДРЕС: '\(url.absoluteString)'")
        
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
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: jsonParameters, options: []) else {
            print("❌ Ошибка сериализации JSON")
            return
        }
        request.httpBody = httpBody
        
        // Вместо жесткого выключения кнопки (которое ломало CoreGraphics), просто делаем её прозрачной визуально
        sendButton.alpha = 0.4
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.sendButton.alpha = 1.0
                
                if let error = error {
                    print("❌ ОШИБКА СЕТИ iOS: \(error.localizedDescription)")
                    self?.showResultAlert(title: "Ошибка сети", message: "Не удалось связаться с сервером.")
                    return
                }
                
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("📬 ПОЛНЫЙ ОТВЕТ ОТ СЕРВЕРА TELEGRAM: \(responseString)")
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("📊 HTTP STATUS CODE ОТ СЕРВЕРА: \(httpResponse.statusCode)")
                    
                    if httpResponse.statusCode == 200 {
                        self?.messageTextView.text = "Ваше сообщение..."
                        self?.messageTextView.textColor = .placeholderText
                        self?.textFieldsChanged() // Сбрасываем кнопку в серый цвет
                        
                        self?.showResultAlert(title: "Успешно", message: "Ваше обращение доставлено техподдержке!") {
                            self?.navigationController?.popViewController(animated: true)
                        }
                    } else {
                        self?.showResultAlert(title: "Ошибка отправки", message: "Сервер вернул код: \(httpResponse.statusCode). Проверьте настройки чата.")
                    }
                }
            }
        }.resume()
    }


        // функция проверки textFieldsChanged()
    @objc func textFieldsChanged() {
        // Просто даем команду кнопке: "Элементы на экране изменились, обнови свои цвета!"
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
