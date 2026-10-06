import UIKit

extension UIColor {
    
    /// Глобальный фон для всех экранов приложения
    static var appBackground: UIColor {
        return UIColor { traitCollection in
            // Система сама говорит нам, какой режим сейчас активен в окне
            return traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.12, green: 0.12, blue: 0.13, alpha: 1.0) // Фирменный тёмно-серый
                : .white // Светлый фон
        }
    }
    
    /// Глобальный цвет для карточек (например, ячейки на экране Истории)
    static var appCardBackground: UIColor {
        return UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.18, green: 0.18, blue: 0.20, alpha: 1.0)
                : UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        }
    }
    
    /// Глобальный цвет для тонких линий, рамок и разделителей
    static var appSeparator: UIColor {
        return UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.22, green: 0.22, blue: 0.24, alpha: 1.0)
                : UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.0)
        }
    }
    
    /// Фирменный желтый акцент
    static var appAccent: UIColor {
        return UIColor(red: 0.98, green: 0.82, blue: 0.24, alpha: 1.0)
    }
    
    /// Универсальный адаптивный цвет текста (белый для темной темы, темно-угольный для светлой)
    static var appText: UIColor {
        return UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark
                ? .white
                : UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0)
        }
    }
    
    /// Второстепенный текст (серый для темной, темно-серый для светлой)
    static var appSecondaryText: UIColor {
        return UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .systemGray2 : .darkGray
        }
    }
    
    /// Напоминалка: текст
    static var customReminderText: UIColor {
        return UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.60, green: 0.85, blue: 0.65, alpha: 1.0)
                : UIColor(red: 0.15, green: 0.25, blue: 0.18, alpha: 1.0)
        }
    }
    
    /// Напоминалка: граница
    static var customReminderBorder: UIColor {
        return UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark
                ? UIColor(red: 0.20, green: 0.40, blue: 0.25, alpha: 1.0)
                : UIColor(red: 0.85, green: 0.90, blue: 0.85, alpha: 1.0)
        }
    }
    
    /// БЕЗОПАСНЫЙ МЕТОД: Настраивает только глобальные бары и системные контейнеры.
    static func applyGlobalTheme(for viewController: UIViewController, withTableView tableView: UITableView? = nil) {
        viewController.view.backgroundColor = .appBackground
        
        if let tv = tableView {
            tv.backgroundColor = .clear
            tv.separatorColor = .appSeparator
        }
        
        if let navBar = viewController.navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .appBackground
            appearance.titleTextAttributes = [.foregroundColor: UIColor.appText]
            
            navBar.standardAppearance = appearance
            navBar.scrollEdgeAppearance = appearance
            navBar.tintColor = .appText
        }
        
        if let tabBar = viewController.tabBarController?.tabBar {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .appBackground
            
            appearance.stackedLayoutAppearance.selected.iconColor = .appAccent
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.appAccent]
            
            appearance.stackedLayoutAppearance.normal.iconColor = .appSecondaryText
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.appSecondaryText]
            
            tabBar.standardAppearance = appearance
            if #available(iOS 15.0, *) { tabBar.scrollEdgeAppearance = appearance }
            tabBar.tintColor = .appAccent
            tabBar.unselectedItemTintColor = .appSecondaryText
        }
    }
}
