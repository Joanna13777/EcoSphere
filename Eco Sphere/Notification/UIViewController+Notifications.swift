// научим сквозной колокольчик (который отображается на экране «Виды» и других экранах) слушать сигналы изменения статуса и менять свой цвет

import UIKit

extension UIViewController {
    
    func setupNotificationNavigationButton() {
        updateBellButtonColor()
        
        // Подписываем экран на отслеживание статуса прочтения уведомлений
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("AppNotificationStatusChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(globalNotificationStatusUpdated), name: NSNotification.Name("AppNotificationStatusChanged"), object: nil)
    }
    
    @objc private func globalNotificationStatusUpdated() {
        // Возвращаемся в главный поток интерфейса и перерисовываем цвет иконки
        DispatchQueue.main.async {
            self.updateBellButtonColor()
        }
    }
    
    private func updateBellButtonColor() {
        let hasUnread = NotificationManager.shared.hasUnread()
        
        // Если есть непрочитанные — колокольчик горит зелёным, если нет — обычным цветом темы (.label)
        let bellColor: UIColor = hasUnread ? .systemGreen : .label
        let bellImage = UIImage(systemName: hasUnread ? "bell.badge.fill" : "bell.fill") // Добавляем точку-бейджик, если не прочтено
        
        let bellButton = UIBarButtonItem(image: bellImage, style: .plain, target: self, action: #selector(globalNotificationTapped))
        bellButton.tintColor = bellColor
        
        navigationItem.rightBarButtonItem = bellButton
    }
    
    @objc private func globalNotificationTapped() {
        let notificationVC = NotificationCenterViewController()
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.pushViewController(notificationVC, animated: true)
    }
}
