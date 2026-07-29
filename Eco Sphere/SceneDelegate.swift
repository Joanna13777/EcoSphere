import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // 1. Убеждаемся, что системная сцена — это окно устройства (Window Scene)
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // 2. Создаем структуру окна, заполняющую весь физический дисплей
        let window = UIWindow(windowScene: windowScene)
        
        // Регистрируем дефолтное значение для первого запуска, если оно еще не создано
        UserDefaults.standard.register(defaults: ["is_first_launch": true])
        
        // Экран 1 (Выбор языка) всегда отображается при запуске приложения.
        // Оборачиваем его в UINavigationController, чтобы работала кнопка Back на экранах онбординга.
        _ = LanguageViewController()
        let splashVC = SplashViewController()
        let rootNavigationController = UINavigationController(rootViewController: splashVC)
        rootNavigationController.isNavigationBarHidden = true
        
        // Назначаем навигационный контроллер главным для этого окна
        window.rootViewController = rootNavigationController
        
        // 5. Сохраняем окно в памяти и делаем его видимым на экране смартфона
        self.window = window
        window.makeKeyAndVisible()
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
