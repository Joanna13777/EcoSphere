import UIKit

// MARK: - Глобальная палитра цветов приложения
extension UIColor {
    
    private static let themeKey = "selected_app_theme"
    
    /// Глобальный фон для всех экранов приложения
    static var appBackground: UIColor {
        return UIColor { traitCollection in
            let isDarkTheme = UserDefaults.standard.integer(forKey: themeKey) == 1
            if isDarkTheme {
                return UIColor(red: 0.12, green: 0.12, blue: 0.13, alpha: 1.0) // Тёмно-серый
            } else {
                return UIColor.white // Светлый фон
            }
        }
    }
    
    /// Глобальный цвет для карточек (например, ячейки на экране Истории)
    static var appCardBackground: UIColor {
        return UIColor { traitCollection in
            let isDarkTheme = UserDefaults.standard.integer(forKey: themeKey) == 1
            if isDarkTheme {
                return UIColor(red: 0.18, green: 0.18, blue: 0.20, alpha: 1.0)
            } else {
                return UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
            }
        }
    }
    
    /// Глобальный цвет для тонких линий и разделителей
    static var appSeparator: UIColor {
        return UIColor { traitCollection in
            let isDarkTheme = UserDefaults.standard.integer(forKey: themeKey) == 1
            if isDarkTheme {
                return UIColor(red: 0.22, green: 0.22, blue: 0.24, alpha: 1.0)
            } else {
                return UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.0)
            }
        }
    }
    
    /// Фирменный желтый акцент
    static var appAccent: UIColor {
        return UIColor(red: 0.98, green: 0.82, blue: 0.24, alpha: 1.0)
    }
    
    /// Глобальный метод для безопасной покраски фонов, таблиц, баров и текстов
    static func applyGlobalTheme(for viewController: UIViewController, withTableView tableView: UITableView? = nil) {
        let themeKey = "selected_app_theme"
        let isDark = UserDefaults.standard.integer(forKey: themeKey) == 1
        
        // 1. Назначаем экрану наш умный динамический цвет фона
        viewController.view.backgroundColor = .appBackground
        
        // 2. Если на экране есть таблица — делаем её прозрачной
        if let tv = tableView {
            tv.backgroundColor = .clear
            tv.separatorColor = .appSeparator
        }
        
        // 3. НАСТРОЙКА НИЖНЕГО БАРА (TAB BAR) ДЛЯ ТЁМНОЙ ТЕМЫ
        if let tabBar = viewController.tabBarController?.tabBar {
            let tabBarBgColor = isDark ? UIColor.systemGray6 : UIColor.white
            tabBar.barTintColor = tabBarBgColor
            tabBar.backgroundColor = tabBarBgColor
            tabBar.backgroundImage = nil
            tabBar.shadowImage = nil
            
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = tabBarBgColor
            
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor(red: 0.98, green: 0.82, blue: 0.24, alpha: 1.0)
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(red: 0.98, green: 0.82, blue: 0.24, alpha: 1.0)]
            
            let normalColor = isDark ? UIColor.systemGray : UIColor.darkGray
            appearance.stackedLayoutAppearance.normal.iconColor = normalColor
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: normalColor]
            
            tabBar.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = appearance
            }
            tabBar.unselectedItemTintColor = normalColor
            tabBar.tintColor = UIColor(red: 0.98, green: 0.82, blue: 0.24, alpha: 1.0)
            
            // 5. АВТОМАТИЧЕСКАЯ НАСТРОЙКА ВЕРХНЕГО БАРА ДЛЯ ЭКРАНОВ МЕНЮ
            if let navBar = viewController.navigationController?.navigationBar {
                let themeColor = UIColor.appBackground
                
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = themeColor // Панель подстраивается под фон темы
                
                // Заголовок экрана («История», «Профиль») станет белым в тёмной теме и чёрным в светлой
                appearance.titleTextAttributes = [.foregroundColor: isDark ? UIColor.white : UIColor.black]
                
                navBar.standardAppearance = appearance
                navBar.scrollEdgeAppearance = appearance
                
                // Системная стрелочка «Назад» станет белой в тёмной теме и чёрной в светлой
                navBar.tintColor = isDark ? UIColor.white : UIColor.black
            }
            
            // Настройка для кастомных левых BarButtonItem кнопок «Назад» (если они созданы кодом)
            if let leftItem = viewController.navigationItem.leftBarButtonItem {
                leftItem.tintColor = isDark ? .white : .black
            }

        }
        
        // 4. БЕЗОПАСНЫЙ РЕКУРСИВНЫЙ СКАНЕР
        func scanAndColorViews(_ subviews: [UIView]) {
            subviews.forEach { subview in
                
                // ЗАЩИТА СВЕРХУ: Исключаем инфо-плашки экрана Виды по нашему тегу
                if subview.tag == 999 || subview.superview?.tag == 999 {
                    return
                }
                
                // СИСТЕМНАЯ ЗАЩИТА: Полностью игнорируем тумблеры (UISwitch), кнопки, коллекции
                // и приватные внутренние контейнеры iOS, чтобы предотвратить ассемблерный крэш jae!
                let isDangerousContainer = subview is UINavigationBar ||
                                           subview is UITabBar ||
                                           subview is UICollectionView ||
                                           subview is UIControl || // Исключает UISwitch, UIButton, UITextField из сканера констрейнтов
                                           String(describing: type(of: subview)).hasPrefix("_") ||
                                           String(describing: type(of: subview)).contains("Cell") // Не лезем во внутренности системных ячеек
                
                if isDangerousContainer { return }
                
                // Прозрачность для таблиц
                if let tv = subview as? UITableView {
                    tv.backgroundColor = .clear
                    tv.separatorColor = .appSeparator
                }
                
                // КРАСИМ ЛЕЙБЛЫ ТЕКСТА
                if let label = subview as? UILabel {
                    // Если у лейбла родитель инфо-карточка — пропускаем
                    if let superview = label.superview,
                       String(describing: type(of: superview)).contains("View") {
                        if label.textColor == UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0) {
                            return
                        }
                    }
                    
                    if label.textColor == UIColor.white { return }
                    
                    if isDark {
                        if label.textColor != UIColor.white && label.textColor != UIColor.clear {
                            label.textColor = .white
                        }
                    } else {
                        label.textColor = UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0)
                    }
                }
                
                // Красим текстовые блоки описаний
                if let textView = subview as? UITextView {
                    textView.backgroundColor = .clear
                    textView.textColor = isDark ? .white : UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0)
                }
                
                // Безопасно уходим на глубину обычных UIView, UIScrollView и UIStackView
                if !subview.subviews.isEmpty {
                    scanAndColorViews(subview.subviews)
                }
            }
        }
        
        scanAndColorViews(viewController.view.subviews)
    }

}
