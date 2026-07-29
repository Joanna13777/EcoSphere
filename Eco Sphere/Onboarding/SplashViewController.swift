import UIKit

class SplashViewController: UIViewController {
    
    private let logoImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // ОБЯЗАТЕЛЬНО: добавляем вызов верстки логотипа
        setupLogoLayout()
        determineNextScreen()
    }
    
    private func setupLogoLayout() {
        // Загружаем независимый ассет логотипа
        if let logoImage = UIImage(named: "app_logo") {
            logoImageView.image = logoImage
//        } else {
//            logoImageView.image = UIImage(systemName: "leaf.fill")
//            logoImageView.tintColor = UIColor(red: 27/255, green: 94/255, blue: 32/255, alpha: 1)
            print("Предупреждение: Добавьте изображение с именем 'app_logo' в Assets!")
        }
        
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        
        // Констреинты для центрирования логотипа
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor)
        ])
    }
    
    private func determineNextScreen() {
        // Задержка 1.5 секунды, чтобы пользователь успел увидеть логотип
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            // Исправлено: проверяем, что self еще жив, но не создаем неиспользуемую переменную
            guard self != nil else { return }
            
            // 1. Получаем доступ к текущему окну через современный UIWindowScene API
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else { return }
            
            // 2. Читаем флаг первого запуска
            let isFirstLaunch = UserDefaults.standard.bool(forKey: "is_first_launch")
            
            if isFirstLaunch {
                // ПЕРВЫЙ ЗАПУСК: Инициализируем онбординг.
                let onboardingVC = OnboardingViewController()
                let rootNavigationController = UINavigationController(rootViewController: onboardingVC)
                rootNavigationController.isNavigationBarHidden = true
                
                // Назначаем его главным экраном
                window.rootViewController = rootNavigationController
            } else {
                // ПОВТОРНЫЙ ЗАПУСК: Идем сразу в главный таб-бар, минуя онбординг
                let mainTabBar = MainTabBarController()
                window.rootViewController = mainTabBar
            }
            
            // 3. Запускаем красивую плавную анимацию смены экранов для обоих сценариев
            UIView.transition(with: window,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }
}
