import Foundation

// MARK: - Модель отдельного сообщения внутри тикета
struct SupportMessage: Codable {
    let id: UUID
    let sender: MessageSender
    let text: String
    let date: Date
    let attachedImageData: Data? // Для хранения прикрепленного скриншота/фото
}

enum MessageSender: String, Codable {
    case user      // Сообщение от клиента
    case operator_ // Ответ от техподдержки
}

// MARK: - Модель обращения (Тикета)
struct SupportChatRequest: Codable {
    let id: UUID
    let shortId: Int // Уникальный номер обращения (например, 1410919 из Скрина 1)
    let category: String
    let date: Date
    var messages: [SupportMessage] // Массив всех сообщений (переписка)
    
    // Получение самого первого (исходного) сообщения для отображения в списке истории
    var firstMessageText: String {
        return messages.first(where: { $0.sender == .user })?.text ?? "Нет текста"
    }
    
    var formattedDate: String {
        return SupportChatManager.sharedDateFormatter.string(from: date)
    }
}

enum SupportSortCriterion {
    case dateNewest
    case dateOldest
    case category
}
