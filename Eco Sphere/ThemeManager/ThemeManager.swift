import UIKit

class ThemeManager {
    static let shared = ThemeManager()
    private let themeKey = "selected_app_theme"
    
    enum AppTheme: Int {
        case light = 0
        case dark = 1
    }
    
    // Наш фирменный тёмно-серый цвет для тёмной темы
    let customDarkGray = UIColor(red: 0.12, green: 0.12, blue: 0.13, alpha: 1.0)
    
    // ГЛОБАЛЬНЫЙ ДИНАМИЧЕСКИЙ ЦВЕТ ФОНА ДЛЯ ВСЕХ ЭКРАНОВ ПРИЛОЖЕНИЯ
    lazy var appBackgroundColor: UIColor = {
        return UIColor { [weak self] traitCollection in
            guard let self = self else { return .white }
            // Проверяем, включена ли тёмная тема в UserDefaults
            let savedTheme = UserDefaults.standard.integer(forKey: self.themeKey)
            return (savedTheme == 1) ? self.customDarkGray : UIColor.white
        }
    }()
    
    // ГЛОБАЛЬНЫЙ ДИНАМИЧЕСКИЙ ЦВЕТ РАЗДЕЛИТЕЛЕЙ И РАМОК
    lazy var appSeparatorColor: UIColor = {
        return UIColor { [weak self] traitCollection in
            guard let self = self else { return UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.0) }
            let savedTheme = UserDefaults.standard.integer(forKey: self.themeKey)
            return (savedTheme == 1) ? UIColor(red: 0.22, green: 0.22, blue: 0.24, alpha: 1.0) : UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.0)
        }
    }()
    
    func applyTheme(_ theme: AppTheme) {
        // 1. Просто сохраняем выбор пользователя в память устройства
        UserDefaults.standard.set(theme.rawValue, forKey: themeKey)
        UserDefaults.standard.synchronize()
        
        if #available(iOS 13.0, *) {
            let style: UIUserInterfaceStyle = (theme == .dark) ? .dark : .light
            
            // 2. Меняем стиль интерфейса для окон.
            // Система iOS сама перерисует .appBackground на экранах без вылетов!
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .forEach { window in
                    window.overrideUserInterfaceStyle = style
                    window.backgroundColor = .appBackground
                }
            
            // 3. Настройка верхних навигационных баров
            let navAppearance = UINavigationBarAppearance()
            navAppearance.configureWithOpaqueBackground()
            navAppearance.backgroundColor = .appBackground
            navAppearance.titleTextAttributes = [.foregroundColor: (theme == .dark) ? UIColor.white : UIColor.black]
            
            UINavigationBar.appearance().standardAppearance = navAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
            UINavigationBar.appearance().tintColor = (theme == .dark) ? UIColor.white : UIColor.black
            
            // 4. Настройка нижнего таб-бара
            let tabAppearance = UITabBarAppearance()
            tabAppearance.configureWithOpaqueBackground()
            tabAppearance.backgroundColor = .appBackground
            
            tabAppearance.stackedLayoutAppearance.selected.iconColor = UIColor.appAccent
            tabAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.appAccent]
            
            let grayColor = (theme == .dark) ? UIColor.systemGray2 : UIColor.systemGray
            tabAppearance.stackedLayoutAppearance.normal.iconColor = grayColor
            tabAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: grayColor]
            
            UITabBar.appearance().standardAppearance = tabAppearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabAppearance
            }
        }
    }

    
    func loadSavedTheme() {
        let savedRawValue = UserDefaults.standard.integer(forKey: themeKey)
        let savedTheme = AppTheme(rawValue: savedRawValue) ?? .light
        applyTheme(savedTheme)
    }
    
    func getSavedUserInterfaceStyle() -> UIUserInterfaceStyle {
        let savedRawValue = UserDefaults.standard.integer(forKey: themeKey)
        return (savedRawValue == 1) ? .dark : .light
    }
}
