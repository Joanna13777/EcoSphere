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




//import UIKit
//
//// MARK: - Глобальная палитра цветов приложения
//extension UIColor {
//    
//    private static let themeKey = "selected_app_theme"
//    
//    /// Глобальный фон для всех экранов приложения
//    static var appBackground: UIColor {
//        return UIColor { traitCollection in
//            let isDarkTheme = UserDefaults.standard.integer(forKey: themeKey) == 1
//            if isDarkTheme {
//                return UIColor(red: 0.12, green: 0.12, blue: 0.13, alpha: 1.0) // Тёмно-серый
//            } else {
//                return UIColor.white // Светлый фон
//            }
//        }
//    }
//    
//    /// Глобальный цвет для карточек (например, ячейки на экране Истории)
//    static var appCardBackground: UIColor {
//        return UIColor { traitCollection in
//            let isDarkTheme = UserDefaults.standard.integer(forKey: themeKey) == 1
//            if isDarkTheme {
//                return UIColor(red: 0.18, green: 0.18, blue: 0.20, alpha: 1.0)
//            } else {
//                return UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
//            }
//        }
//    }
//    
//    /// Глобальный цвет для тонких линий и разделителей
//    static var appSeparator: UIColor {
//        return UIColor { traitCollection in
//            let isDarkTheme = UserDefaults.standard.integer(forKey: themeKey) == 1
//            if isDarkTheme {
//                return UIColor(red: 0.22, green: 0.22, blue: 0.24, alpha: 1.0)
//            } else {
//                return UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.0)
//            }
//        }
//    }
//    
//    /// Фирменный желтый акцент
//    static var appAccent: UIColor {
//        return UIColor(red: 0.98, green: 0.82, blue: 0.24, alpha: 1.0)
//    }
//    
//    /// Глобальный метод для безопасной покраски фонов, таблиц, баров и текстов
//    static func applyGlobalTheme(for viewController: UIViewController, withTableView tableView: UITableView? = nil) {
//        let themeKey = "selected_app_theme"
//        let isDark = UserDefaults.standard.integer(forKey: themeKey) == 1
//        
//        // 1. Назначаем экрану наш умный динамический цвет фона
//        viewController.view.backgroundColor = .appBackground
//        
//        // 2. Если на экране есть таблица — делаем её прозрачной
//        if let tv = tableView {
//            tv.backgroundColor = .clear
//            tv.separatorColor = .appSeparator
//        }
//        
//        // 3. НАСТРОЙКА НИЖНЕГО БАРА (TAB BAR) ДЛЯ ТЁМНОЙ ТЕМЫ
//        if let tabBar = viewController.tabBarController?.tabBar {
//            let tabBarBgColor = isDark ? UIColor.systemGray6 : UIColor.white
//            tabBar.barTintColor = tabBarBgColor
//            tabBar.backgroundColor = tabBarBgColor
//            tabBar.backgroundImage = nil
//            tabBar.shadowImage = nil
//            
//            let appearance = UITabBarAppearance()
//            appearance.configureWithOpaqueBackground()
//            appearance.backgroundColor = tabBarBgColor
//            
//            appearance.stackedLayoutAppearance.selected.iconColor = UIColor(red: 0.98, green: 0.82, blue: 0.24, alpha: 1.0)
//            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(red: 0.98, green: 0.82, blue: 0.24, alpha: 1.0)]
//            
//            let normalColor = isDark ? UIColor.systemGray : UIColor.darkGray
//            appearance.stackedLayoutAppearance.normal.iconColor = normalColor
//            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: normalColor]
//            
//            tabBar.standardAppearance = appearance
//            if #available(iOS 15.0, *) {
//                tabBar.scrollEdgeAppearance = appearance
//            }
//            tabBar.unselectedItemTintColor = normalColor
//            tabBar.tintColor = UIColor(red: 0.98, green: 0.82, blue: 0.24, alpha: 1.0)
//            
//            // 5. АВТОМАТИЧЕСКАЯ НАСТРОЙКА ВЕРХНЕГО БАРА ДЛЯ ЭКРАНОВ МЕНЮ
//            if let navBar = viewController.navigationController?.navigationBar {
//                let themeColor = UIColor.appBackground
//                
//                let appearance = UINavigationBarAppearance()
//                appearance.configureWithOpaqueBackground()
//                appearance.backgroundColor = themeColor // Панель подстраивается под фон темы
//                
//                // Заголовок экрана («История», «Профиль») станет белым в тёмной теме и чёрным в светлой
//                appearance.titleTextAttributes = [.foregroundColor: isDark ? UIColor.white : UIColor.black]
//                
//                navBar.standardAppearance = appearance
//                navBar.scrollEdgeAppearance = appearance
//                
//                // Системная стрелочка «Назад» станет белой в тёмной теме и чёрной в светлой
//                navBar.tintColor = isDark ? UIColor.white : UIColor.black
//            }
//            
//            // Настройка для кастомных левых BarButtonItem кнопок «Назад» (если они созданы кодом)
//            if let leftItem = viewController.navigationItem.leftBarButtonItem {
//                leftItem.tintColor = isDark ? .white : .black
//            }
//
//        }
//        
//        // 4. БЕЗОПАСНЫЙ РЕКУРСИВНЫЙ СКАНЕР
//        func scanAndColorViews(_ subviews: [UIView]) {
//            subviews.forEach { subview in
//                
//                // Исключаем инфо-плашки экрана Виды по нашему тегу
//                if subview.tag == 999 || subview.superview?.tag == 999 { return }
//                
//                // Системные исключения (оставляем бары и приватные слои Apple)
//                let isDangerousSystemContainer = subview is UINavigationBar ||
//                                                 subview is UITabBar ||
//                                                 String(describing: type(of: subview)).hasPrefix("_") ||
//                                                 String(describing: type(of: subview)).contains("Cell")
//                
//                if isDangerousSystemContainer { return }
//                
//                // === МАГИЯ: НАХОДИМ ЛЮБЫЕ КАСТОМНЫЕ КНОПКИ НА ЭКРАНЕ И КРАСИМ ИХ ИКОНКИ ===
//                if let button = subview as? UIButton {
//                    // Красим стрелочку внутри кнопки в белый цвет для тёмной темы и в чёрный для светлой
//                    button.tintColor = isDark ? .white : .black
//                    button.imageView?.tintColor = isDark ? .white : .black
//                }
//                
//                // На всякий случай проверяем, если стрелочка сделана просто как кликабельная картинка
//                if let imageView = subview as? UIImageView {
//                    // Если у картинки включен режим шаблона (tintable), красим её
//                    if imageView.image?.renderingMode == .alwaysTemplate || imageView.tintColor != .clear {
//                        imageView.tintColor = isDark ? .white : .black
//                    }
//                }
//                
//                // Прозрачность для таблиц
//                if let tv = subview as? UITableView { tv.backgroundColor = .clear }
//                
//                // КРАСИМ ЛЕЙБЛЫ ТЕКСТА
//                if let label = subview as? UILabel {
//                    if let superview = label.superview, String(describing: type(of: superview)).contains("View") {
//                        if label.textColor == UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0) { return }
//                    }
//                    if label.textColor == UIColor.white { return }
//                    
//                    label.textColor = isDark ? .white : UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0)
//                }
//                
//                // Красим текстовые блоки описаний
//                if let textView = subview as? UITextView {
//                    textView.backgroundColor = .clear
//                    textView.textColor = isDark ? .white : UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0)
//                }
//                
//                // Уходим на глубину ваших кастомных стеков разметки
//                if !subview.subviews.isEmpty {
//                    scanAndColorViews(subview.subviews)
//                }
//            }
//        }
//
//        
//        scanAndColorViews(viewController.view.subviews)
//    }
//
//}
