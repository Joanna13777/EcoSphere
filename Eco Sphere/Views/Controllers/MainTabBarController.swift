// нижний бар в стиле Eco-Minimalism

import UIKit

class MainTabBarController: UITabBarController {
    
    // Палитра цветов для таб-бара
    private let accentYellowColor = UIColor(red: 0.96, green: 0.71, blue: 0.10, alpha: 1.0)  // #F4B41A
    private let secondaryTextColor = UIColor(red: 0.49, green: 0.49, blue: 0.49, alpha: 1.0) // #7E7E7E
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        // --- 1. ГЛОБАЛЬНАЯ НАСТРОЙКА ВЕРХНЕГО НАВИГАЦИОННОГО БАРА (ЧЕРНЫЙ ЦВЕТ ЗАГОЛОВКА И СТРЕЛКИ) ---
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .white // Чистый белый фон верхнего бара
        
        // Задаем глубокий черный цвет для текста вверху рядом со стрелкой back
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        
        // Применяем внешний вид ко всем UINavigationBar в приложении
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        
        // Делаем иконку стрелки назад «chevron.left» строго черной по всему приложению
        UINavigationBar.appearance().tintColor = .black
        
        // --- 2. НАСТРОЙКА НИЖНЕГО ТАБ-БАРА ---
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white // Чистый белый фон таб-бара
        
        // Настройка теней таб-бара (мягкая вуальная тень)
        appearance.shadowColor = .clear
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.04
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -4)
        tabBar.layer.shadowRadius = 10
        
        let itemAppearance = UITabBarItemAppearance()
        
        // Неактивное состояние вкладок
        itemAppearance.normal.iconColor = secondaryTextColor
        itemAppearance.normal.titleTextAttributes = [
            .foregroundColor: secondaryTextColor,
            .font: UIFont.systemFont(ofSize: 11, weight: .medium)
        ]
        
        // Активное состояние вкладок (сочно-желтый цвет)
        itemAppearance.selected.iconColor = accentYellowColor
        itemAppearance.selected.titleTextAttributes = [
            .foregroundColor: accentYellowColor,
            .font: UIFont.systemFont(ofSize: 11, weight: .semibold)
        ]
        
        appearance.stackedLayoutAppearance = itemAppearance
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        // --- 3. ИНИЦИАЛИЗАЦИЯ СТЕКА ЭКРАНОВ ДЛЯ ВКЛАДОК ---
        let viewsVC = MainContainerViewController()
        let nav1 = UINavigationController(rootViewController: viewsVC)
        nav1.tabBarItem = UITabBarItem(title: "Виды", image: UIImage(systemName: "arrow.3.trianglepath"), tag: 0)
        
        let sortingVC = SortingViewController()
        let nav2 = UINavigationController(rootViewController: sortingVC)
        nav2.tabBarItem = UITabBarItem(title: "Сортировка", image: UIImage(systemName: "square.grid.2x2"), tag: 1)
        
        let pointsVC = MapViewController()
        let nav3 = UINavigationController(rootViewController: pointsVC)
        nav3.tabBarItem = UITabBarItem(title: "Пункты", image: UIImage(systemName: "mappin.and.ellipse"), tag: 2)
        
        viewControllers = [nav1, nav2, nav3]
    }
}
    private func id(of object: AnyObject) -> String {
        return String(describing: type(of: object))
    }

