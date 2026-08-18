import UIKit

// MARK: - Структура данных заказа
struct HistoryOrder {
    let wasteType: String
    let iconName: String
    let iconColor: UIColor
    let date: String
    let weight: String
    let address: String
    let status: String
    let isCompleted: Bool
}

// MARK: - Глобальный менеджер заказов (Склад данных)
class OrderManager {
    
    // Единый источник правды для всего приложения
    static let shared = OrderManager()
    
    // Массив, в который будут динамически добавляться новые заказы
    var orders: [HistoryOrder] = []
    
    private init() {
        // Заполняем базу начальными тестовыми данными, чтобы экраны не были пустыми
        setupMockData()
    }
    
    private func setupMockData() {
        orders = [
            HistoryOrder(wasteType: "Макулатура (бумага)", iconName: "doc.text.fill", iconColor: .systemBlue, date: "21 сентября, 18:30", weight: "12 кг", address: "ул. Амира Темура, 14", status: "Выполнено", isCompleted: true),
            HistoryOrder(wasteType: "Пластик", iconName: "capsule.fill", iconColor: UIColor(red: 0.96, green: 0.71, blue: 0.10, alpha: 1.0), date: "14 сентября, 12:00", weight: "5 кг", address: "проспект Навои, 89", status: "Выполнено", isCompleted: true)
        ]
    }
    
    // Метод для добавления нового заказа с любого экрана
    func addNewOrder(_ order: HistoryOrder) {
        orders.insert(order, at: 0) // Добавляем в самое начало списка, чтобы новый заказ был сверху
    }
}
