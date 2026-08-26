import UIKit

class SavedAddressesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 1. Показываем верхнюю панель навигации
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        // 2. Убираем системный текст "Back", оставляя только стрелочку «Назад»
        navigationItem.backButtonTitle = ""
        
        // 3. Красим фон, верхний бар и стрелочку под активную светлую или темную тему
        UIColor.applyGlobalTheme(for: self)
    }
    
    // MARK: - Настройка разметки
    private func setupLayout() {
        view.backgroundColor = .appBackground
        
        let label = UILabel()
        label.text = "Список сохраненных адресов"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        
        // ИСПРАВЛЕНИЕ: Текст теперь сам станет светлым в темной теме!
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
