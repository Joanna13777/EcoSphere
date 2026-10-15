//
//  SupportChatManager.swift
//  Eco Sphere
//
//  Created by Жанна Сергеевна  on 15/10/26.
//

import UIKit

class SupportChatManager {
    static let shared = SupportChatManager()
    private let storageKey = "saved_support_chat_requests"
    
    static let sharedDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd.MM.yyyy HH:mm" 
        return formatter
    }()

    var requests: [SupportChatRequest] = []
    
    private init() {
        loadRequests()
    }
    
    // принимает текст и опциональное фото
    func addNewRequest(category: String, message: String, attachmentData: Data?) {
        // Генерируем красивый 6-значный ID (например, от 100000 до 999999)
        let randomShortId = Int.random(in: 100000...999999)
        
        let firstMessage = SupportMessage(
            id: UUID(),
            sender: .user,
            text: message,
            date: Date(),
            attachedImageData: attachmentData
        )
        
        let newRequest = SupportChatRequest(
            id: UUID(),
            shortId: randomShortId,
            category: category,
            date: Date(),
            messages: [firstMessage]
        )
        
        requests.insert(newRequest, at: 0)
        saveRequests()
    }
    
    // Добавление нового сообщения в уже существующий диалог (когда оператор ответил или юзер дописал)
    func addMessageToChat(requestId: UUID, text: String, sender: MessageSender, imageData: Data? = nil) {
        if let index = requests.firstIndex(where: { $0.id == requestId }) {
            let newMessage = SupportMessage(id: UUID(), sender: sender, text: text, date: Date(), attachedImageData: imageData)
            requests[index].messages.append(newMessage)
            saveRequests()
        }
    }
    
    func getSortedRequests(by criterion: SupportSortCriterion) -> [SupportChatRequest] {
        switch criterion {
        case .dateNewest: return requests.sorted { $0.date > $1.date }
        case .dateOldest: return requests.sorted { $0.date < $1.date }
        case .category: return requests.sorted { $0.category.localizedCaseInsensitiveCompare($1.category) == .orderedAscending }
        }
    }
    
    func deleteRequest(id: UUID) {
        if let index = requests.firstIndex(where: { $0.id == id }) {
            requests.remove(at: index)
            saveRequests()
        }
    }
    
    private func saveRequests() {
        if let encoded = try? JSONEncoder().encode(requests) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    private func loadRequests() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([SupportChatRequest].self, from: data) {
            self.requests = decoded
        }
    }
}
