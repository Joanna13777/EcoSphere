// Экран уведомления. вся бизнес-логика: запись в базу данных UserDefaults, нативный звук трилла при получении и управление статусами прочтения (смена цвета колокольчика)

import Foundation
import AudioToolbox // Библиотека Apple для мгновенного проигрывания системных звуков

class NotificationManager {
    static let shared = NotificationManager()
    
    private let storageKey = "app_local_notifications"
    private let unreadKey = "app_notifications_has_unread"
    
    // MARK: - Управление статусом прочтения (Цветом колокольчика)
    
    /// Проверить, есть ли в приложении новые непрочитанные уведомления
    func hasUnread() -> Bool {
        return UserDefaults.standard.bool(forKey: unreadKey)
    }
    
    /// Установить статус прочтения (вызовется, когда пользователь откроет экран уведомлений)
    func setHasUnread(_ unread: Bool) {
        UserDefaults.standard.set(unread, forKey: unreadKey)
        
        // Посылаем сигнал по всему приложению, чтобы все колокольчики (в Меню и Видах) мгновенно обновили цвет
        NotificationCenter.default.post(name: NSNotification.Name("AppNotificationStatusChanged"), object: nil)
    }
    
    // MARK: - Работа с Хранилищем данных
    
    /// Считать всю историю уведомлений из памяти устройства
    func getNotifications() -> [AppNotification] {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let list = try? JSONDecoder().decode([AppNotification].self, from: data) else {
            return []
        }
        return Array(list.reversed()) // Свежие всегда будут отображаться вверху списка
    }
    
    /// Добавить новое событие, включить звук и покрасить колокольчики в зеленый цвет
    func addNotification(title: String, body: String, type: NotificationType) {
        // 1. Включаем индикатор непрочитанных
        setHasUnread(true)
        
        // 2. Воспроизводим приятный нативный звук трилла (системный код 1003)
        AudioServicesPlaySystemSound(1003)
        
        // 3. Сохраняем карточку в базу данных устройства
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              var currentList = try? JSONDecoder().decode([AppNotification].self, from: data) else {
            var firstList: [AppNotification] = []
            appendAndSave(&firstList, title: title, body: body, type: type)
            return
        }
        
        appendAndSave(&currentList, title: title, body: body, type: type)
    }
    
    private func appendAndSave(_ list: inout [AppNotification], title: String, body: String, type: NotificationType) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy, HH:mm"
        let dateStr = formatter.string(from: Date())
        
        let newNotification = AppNotification(
            id: UUID().uuidString,
            title: title,
            body: body,
            dateString: dateStr,
            type: type
        )
        
        list.append(newNotification)
        
        if let encoded = try? JSONEncoder().encode(list) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    /// Полностью очистить историю уведомлений
    func clearAll() {
        UserDefaults.standard.removeObject(forKey: storageKey)
        setHasUnread(false) // Сбрасываем зеленый цвет колокольчика в дефолтный
    }
}

