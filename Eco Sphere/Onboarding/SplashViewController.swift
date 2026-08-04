import UIKit

class SplashViewController: UIViewController {
    
    // 1. Правильное создание ImageView
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 2. Обязательный фон экрана
        view.backgroundColor = .white
        
        setupLogoLayout()
        determineNextScreen()
    }
    
    private func setupLogoLayout() {
        view.addSubview(logoImageView)
        
        // Проверьте, что в Assets файл называется именно "AppLogo" (НЕ AppIcon!)
        if let logoImage = UIImage(named: "eco_onb") {
            logoImageView.image = logoImage
        } else {
            // Если картинки нет, подставим системную иконку для теста
            logoImageView.image = UIImage(systemName: "leaf.fill")
            logoImageView.tintColor = .systemGreen
            print("⚠️ Предупреждение: Файл 'eco_onb' не найден в Assets. Использована заглушка.")
        }
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.60),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor)
        ])
    }
    
    private func determineNextScreen() {
        // Задержка 2.5 секунды
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            // Гарантированный поиск UIWindow во всех активных сценах
            guard let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow }) else {
                print("❌ Ошибка: Не удалось найти активное UIWindow")
                return
            }
            
            // Логика UserDefaults (исправленная на повторный запуск)
            let hasLaunchedBefore = UserDefaults.standard.bool(forKey: "has_launched_before")
            
            let nextVC: UIViewController
            
            if !hasLaunchedBefore {
                // ПЕРВЫЙ ЗАПУСК
                UserDefaults.standard.set(true, forKey: "has_launched_before")
                let onboardingVC = OnboardingViewController()
                let nav = UINavigationController(rootViewController: onboardingVC)
                nav.isNavigationBarHidden = true
                nextVC = nav
            } else {
                // ПОВТОРНЫЙ ЗАПУСК
                nextVC = MainTabBarController()
            }
            
            // Смена экрана
            window.rootViewController = nextVC
            
            UIView.transition(with: window,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }
}
