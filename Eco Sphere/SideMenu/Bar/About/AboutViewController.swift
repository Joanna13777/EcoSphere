import UIKit

class AboutViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 1. Показываем навигационную панель
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        // 2. Смываем текст "Back" с кнопки "Назад", оставляя только чистую стрелочку
        navigationItem.backButtonTitle = ""
        
        // 3. Принудительно запускаем покраску фона, текстов и верхнего бара под актуальную тему!
        UIColor.applyGlobalTheme(for: self)
    }
    
    // MARK: - Настройка разметки
    private func setupLayout() {
        let label = UILabel()
        label.text = "Версия приложения 1.0.0 (Eco)"
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
