// нижний бар

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        // Системная настройка внешнего вида таб-бара
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white // белый фон таб-бара
        
        // Настройка состояний для элементов
        let itemAppearance = UITabBarItemAppearance()
        
        // 1. Неактивное (негативное) состояние — темно-серый цвет
        itemAppearance.normal.iconColor = .darkGray
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.darkGray]
        
        // 2. Активное (выделенное) состояние — зеленый цвет
        itemAppearance.selected.iconColor = .systemGreen
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemGreen]
        
        appearance.stackedLayoutAppearance = itemAppearance
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
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
    
    // Элегантный метод для добавления светло-серых закругленных квадратов вокруг иконок при отрисовке
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Перебираем все кнопки внутри таб-бара
        let tabBarButtons = tabBar.subviews.filter { id(of: $0) == "UITabBarButton" }
        
        for (_, button) in tabBarButtons.enumerated() {
            // Ищем иконку (ImageView) внутри кнопки таба
            if let imageView = button.subviews.first(where: { $0 is UIImageView }) {
                let backgroundTag = 999
                
                // Проверяем, добавлена ли уже подложка, чтобы не плодить их при каждом повороте экрана
                if button.viewWithTag(backgroundTag) == nil {
                    let bgView = UIView()
                    bgView.tag = backgroundTag
                    bgView.backgroundColor = UIColor(white: 0.95, alpha: 1.0) // Светло-серый фон
                    bgView.layer.cornerRadius = 10 // Закругленные углы
                    bgView.isUserInteractionEnabled = false
                    
                    // Помещаем подложку строго под иконку
                    button.insertSubview(bgView, at: 0)
                    bgView.translatesAutoresizingMaskIntoConstraints = false
                    
                    NSLayoutConstraint.activate([
                        bgView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
                        bgView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
                        bgView.widthAnchor.constraint(equalTo: imageView.widthAnchor, constant: 16),
                        bgView.heightAnchor.constraint(equalTo: imageView.heightAnchor, constant: 12)
                    ])
                }
            }
        }
    }
    
    private func id(of object: AnyObject) -> String {
        return String(describing: type(of: object))
    }
}
