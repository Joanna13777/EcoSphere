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
    
//    // ГЛОБАЛЬНЫЙ ДИНАМИЧЕСКИЙ ЦВЕТ ФОНА ДЛЯ ВСЕХ ЭКРАНОВ ПРИЛОЖЕНИЯ
//    lazy var appBackgroundColor: UIColor = {
//        return .appBackground // Ссылаемся на наше новое адаптивное свойство
//    }()

    lazy var appSeparatorColor: UIColor = {
        return .appSeparator
    }()

    func applyTheme(_ theme: AppTheme) {
        UserDefaults.standard.set(theme.rawValue, forKey: themeKey)
        let style: UIUserInterfaceStyle = (theme == .dark) ? .dark : .light
        
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .forEach { window in
                window.overrideUserInterfaceStyle = style
                window.backgroundColor = .appBackground
            }
        
        // Обновляем Appearance для будущих системных баров
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = .appBackground
        navAppearance.titleTextAttributes = [.foregroundColor: (theme == .dark) ? UIColor.white : UIColor.black]
        
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().tintColor = (theme == .dark) ? UIColor.white : UIColor.black
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
