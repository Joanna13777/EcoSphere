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
        
        // 1. Неактивное состояние
        itemAppearance.normal.iconColor = secondaryTextColor
        itemAppearance.normal.titleTextAttributes = [
            .foregroundColor: secondaryTextColor,
            .font: UIFont.systemFont(ofSize: 11, weight: .medium)
        ]
        
        // 2. Активное состояние (Иконка и текст просто становятся сочно-желтыми, БЕЗ КВАДРАТОВ)
        itemAppearance.selected.iconColor = accentYellowColor
        itemAppearance.selected.titleTextAttributes = [
            .foregroundColor: accentYellowColor,
            .font: UIFont.systemFont(ofSize: 11, weight: .semibold)
        ]
        
        appearance.stackedLayoutAppearance = itemAppearance
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
            
                // UINavigationBar.appearance().tintColor = .black // Сделает иконку стрелки назад черной

        }
        
        // Создаем экраны для вкладок
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

