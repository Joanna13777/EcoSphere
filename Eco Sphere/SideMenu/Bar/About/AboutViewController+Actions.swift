// вся активная бизнес-логика экрана: проверка состояния памяти, обработка тумблера и отправка запроса в Telegram

import UIKit

// MARK: - Настройка Экшенов, Навигации и Проверки флагов
extension AboutViewController {
    
    func setupNavigationBar() {
        title = "О приложении"
        
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
        agreementSwitch.addTarget(self, action: #selector(agreementSwitchChanged), for: .valueChanged)
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
    }
    
    func checkAgreementStatus() {
        
        // 1. Проверяем, вошел ли вообще пользователь в аккаунт
                let isUserLoggedIn = UserDefaults.standard.bool(forKey: "menu_user_logged_in")
                
                // 2. Если пользователь НЕ авторизован (гость), полностью скрываем все элементы согласия
                if !isUserLoggedIn {
                    agreementLabel.isHidden = true
                    agreementSwitch.isHidden = true
                    acceptButton.isHidden = true
                    alreadyAcceptedLabel.isHidden = true // Скрываем и зеленую надпись тоже
                    return // Выходим из функции, дальше проверять оферту нет смысла
                }
                
        // 3. Если пользователь АВТОРИЗОВАН, работает ваша стандартная логика оферты
        let isAccepted = UserDefaults.standard.bool(forKey: "is_agreement_accepted")
        
        if isAccepted {
            agreementLabel.isHidden = true
            agreementSwitch.isHidden = true
            acceptButton.isHidden = true
            alreadyAcceptedLabel.isHidden = false
        } else {
            agreementLabel.isHidden = false
            agreementSwitch.isHidden = false
            acceptButton.isHidden = false
            alreadyAcceptedLabel.isHidden = true
        }
    }
    
    @objc func agreementSwitchChanged(_ sender: UISwitch) {
        acceptButton.isEnabled = sender.isOn
    }
    
    @objc func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Сетевой запрос отправки согласия в Telegram
extension AboutViewController {
    
    @objc func acceptButtonTapped() {
        let defaults = UserDefaults.standard
        let userName = defaults.string(forKey: "user_profile_name") ?? "Неизвестный пользователь"
        let userPhone = defaults.string(forKey: "user_profile_phone") ?? "Номер не указан"
        
        let notificationText = """
        ⚖️ *ПОЛЬЗОВАТЕЛЬ ПРИНЯЛ УСЛОВИЯ ОФЕРТЫ!*
        
        👤 *ФИО:* \(userName)
        📞 *Телефон:* \(userPhone)
        📅 *Статус:* Согласие подтверждено в приложении
        """
        
        let botToken = "8858495099:AAH_Rj7XKCQYmZGNueken7eQA6ni26AvHQQ"
        let chatId = "-1004453945133"
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.telegram.org"
        components.path = "/bot\(botToken)/sendMessage"
        
        guard let url = components.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonParameters: [String: Any] = [
            "chat_id": chatId,
            "text": notificationText,
            "parse_mode": "Markdown"
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: jsonParameters, options: []) else { return }
        request.httpBody = httpBody
        
        acceptButton.alpha = 0.5
        
        URLSession.shared.dataTask(with: request) { [weak self] _, response, _ in
            DispatchQueue.main.async {
                self?.acceptButton.alpha = 1.0
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    // Записываем флаг согласия в память устройства
                    UserDefaults.standard.set(true, forKey: "is_agreement_accepted")
                    
                    // Переключаем элементы видимости на экране
                    self?.checkAgreementStatus()
                    
                    // Выводим всплывающее окно успеха с галочкой
                    let alert = UIAlertController(title: "Успешно", message: "Ваше согласие официально зафиксировано и отправлено в базу данных сервиса.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "✅ Отлично", style: .default, handler: { _ in
                        self?.navigationController?.popViewController(animated: true)
                    }))
                    self?.present(alert, animated: true)
                }
            }
        }.resume()
    }
}

