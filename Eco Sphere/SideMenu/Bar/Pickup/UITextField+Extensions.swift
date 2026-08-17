import UIKit

// MARK: - Глобальные расширения для UITextField
extension UITextField {
    
    func setRightImage(systemName: String, tintColor: UIColor) {
        let iv = UIImageView(image: UIImage(systemName: systemName))
        iv.tintColor = tintColor
        iv.contentMode = .scaleAspectFit
        
        // ВАЖНОЕ ИСПРАВЛЕНИЕ: Отключаем взаимодействие с пользователем для самой картинки.
        // Теперь стрелочка не будет блокировать нажатия, и жест плавно пройдет в текстовое поле!
        iv.isUserInteractionEnabled = false
        
        let paddingContainer = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 20))
        
        // Контейнер тоже делаем прозрачным для кликов, чтобы он не перехватывал тапы
        paddingContainer.isUserInteractionEnabled = false
        
        iv.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        paddingContainer.addSubview(iv)
        
        self.rightView = paddingContainer
        self.rightViewMode = .always
    }
}

// MARK: - Глобальные расширения для UIStackView
extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { self.addArrangedSubview($0) }
    }
}
