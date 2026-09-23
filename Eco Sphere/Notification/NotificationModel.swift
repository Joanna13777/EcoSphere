import Foundation

// MARK: - Структура данных (Убедитесь, что она есть в файле)
struct AppNotification: Codable {
    let id: String
    let title: String
    let body: String
    let dateString: String
    let type: NotificationType
}

enum NotificationType: String, Codable {
    case security      // Вход в систему, регистрация
    case agreement     // Оферта и правила
    case ecoBonus      // Начисление бонусов
    case pickup        // Статусы вывоза мусора
}
