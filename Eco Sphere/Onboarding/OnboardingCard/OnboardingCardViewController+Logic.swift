import UIKit

// MARK: - Бизнес-логика, Локализация и Логика Экшенов
extension OnboardingCardViewController {
    
    func refreshLanguage() {
        updateTextForCurrentLanguage()
    }
    
    func updateTextForCurrentLanguage() {
        let currentLang = UserDefaults.standard.string(forKey: "app_lang") ?? "ru"
        
        // 1. Локализация основного текста
        if let translation = data.translations[currentLang] {
            titleLabel.text = translation.title
            descriptionLabel.text = translation.description
        }
        
        // 2. Локализация кнопки выбора языка
        let flag: String
        switch currentLang {
        case "en": flag = "🇬🇧"
        case "uz": flag = "🇺🇿"
        default: flag = "🇷🇺"
        }
        languageButton.setTitle("\(flag) \(currentLang.uppercased())", for: .normal)
        
        // 3. Локализация главной кнопки "Пропустить" / "Начать"
        let isLastPage = (data.pageIndex == onboardingData.count - 1)
        if isLastPage {
               skipButton.setTitleColor(UIColor(red: 27/255, green: 94/255, blue: 32/255, alpha: 1), for: .normal)
               switch currentLang {
               case "uz": skipButton.setTitle("Boshlash", for: .normal)
               case "en": skipButton.setTitle("Get Started", for: .normal)
               default: skipButton.setTitle("Начать", for: .normal)
               }
           } else {
               skipButton.setTitleColor(.systemGray, for: .normal)
               switch currentLang {
               case "uz": skipButton.setTitle("O'tkazib yuborish", for: .normal)
               case "en": skipButton.setTitle("Skip", for: .normal)
               default: skipButton.setTitle("Пропустить", for: .normal) // Проверьте эту строку!
               }
           }
        
        // 4. НОВАЯ ФИЧА: Локализация кнопки "Регистрация" на 3 языка с сохранением стилей подчеркивания
        let registrationTitle: String
        switch currentLang {
        case "uz": registrationTitle = "Ro'yxatdan o'tish"
        case "en": registrationTitle = "Registration"
        default: registrationTitle = "Регистрация" // ru
        }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15, weight: .medium),
            .foregroundColor: UIColor.systemBlue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        let attributedTitle = NSAttributedString(string: registrationTitle, attributes: attributes)
        registrationButton.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    // MARK: - Экшены нажатий (Selectors)
    
    @objc func pageControlValueChanges(_ sender: UIPageControl) {
        let targetPage = sender.currentPage
        if targetPage >= 0 && targetPage < onboardingData.count {
            onNextPressed?(sender.currentPage)
        }
    }
    
    @objc func languageAction() {
        let currentLang = UserDefaults.standard.string(forKey: "app_lang") ?? "ru"
        let nextLang: String
        switch currentLang {
        case "ru": nextLang = "uz"
        case "uz": nextLang = "en"
        default: nextLang = "ru"
        }
        UserDefaults.standard.set(nextLang, forKey: "app_lang")
        UserDefaults.standard.set([nextLang], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        // Самое главное: обновляем текст на текущем экране и уведомляем родительский контейнер
        updateTextForCurrentLanguage()
        onLanguageChangedGlobal?()
    }
    
    @objc func registrationTapped() {
        let registerVC = RegisterViewController()
        
        if let navigationController = self.navigationController {
            navigationController.pushViewController(registerVC, animated: true)
        } else {
            let navController = UINavigationController(rootViewController: registerVC)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    @objc func backAction() { onBackPressed?() }
    @objc func skipAction() { onSkipPressed?() }
}
