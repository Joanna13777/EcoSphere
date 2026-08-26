import UIKit

class FeedbackViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 1. Показываем верхний бар принудительно
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        // 2. Скрываем текст "Back", оставляя у кнопки «Назад» только стрелочку
        navigationItem.backButtonTitle = ""
        
        // 3. Автоматически перекрашиваем фон, верхний бар и стрелочку под активную тему
        UIColor.applyGlobalTheme(for: self)
    }
    
    // MARK: - Настройка разметки
    private func setupLayout() {
        // Базовый фон экрана по умолчанию
        view.backgroundColor = .appBackground
        
        let label = UILabel()
        label.text = "Напишите нам, мы ответим в течение дня"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        
        // ИСПРАВЛЕНИЕ: Адаптивный цвет вместо жесткого серого (побелеет в тёмной теме)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
