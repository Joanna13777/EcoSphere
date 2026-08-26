import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        //  Глобальное скрытие текста «Back» для всего приложения
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -200, vertical: 0), for: .default)
        
        // 2. Создаем окно приложения
        let window = UIWindow(windowScene: windowScene)
        
        // 3. Загружаем и жестко присваиваем окну сохраненную тему (Светлую или Темную)
        let savedStyle = ThemeManager.shared.getSavedUserInterfaceStyle()
        window.overrideUserInterfaceStyle = savedStyle
        
        // 4. Регистрируем дефолтное значение для первого запуска
        UserDefaults.standard.register(defaults: ["is_first_launch": true])
        
        // 5. Инициализируем стартовую цепочку экранов (Ваш Сплеш-экран)
        let splashVC = SplashViewController()
        let rootNavigationController = UINavigationController(rootViewController: splashVC)
        rootNavigationController.isNavigationBarHidden = true
        
        // Назначаем навигационный контроллер главным для этого окна
        window.rootViewController = rootNavigationController
        
        // 6. Сохраняем окно в памяти и делаем его видимым
        self.window = window
        window.makeKeyAndVisible()
        
        // 7. Обновляем глобальные бары через менеджер
        ThemeManager.shared.loadSavedTheme()
    }



    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
    }
}

