import Foundation

// MARK: - Глобальный менеджер заказов с постоянной памятью
class OrderManager {
    
    static let shared = OrderManager()
    private let storageKey = "user_orders_history_json"
    
    // Массив заказов
    var orders: [HistoryOrder] = []
    
    private init() {
        // Пытаемся загрузить данные из памяти устройства при старте приложения
        loadOrdersFromStorage()
    }
    
    // MARK: - Логика Хранилища
    private func loadOrdersFromStorage() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            // Если памяти устройства пока ничего нет — загружаем тестовые базовые данные
            setupMockData()
            return
        }
        
        do {
            let decoder = JSONDecoder()
            self.orders = try decoder.decode([HistoryOrder].self, from: data)
            print("📦 История успешно загружена из памяти. Найдено заказов: \(orders.count)")
        } catch {
            print("❌ Ошибка декодирования истории заказов: \(error)")
            setupMockData()
        }
    }
    
    private func saveOrdersToStorage() {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(orders)
            UserDefaults.standard.set(encodedData, forKey: storageKey)
            print("💾 Изменения истории успешно зафиксированы в UserDefaults")
        } catch {
            print("❌ Ошибка кодирования истории заказов при сохранении: \(error)")
        }
    }
    
    // MARK: - Публичные методы управления
    func addNewOrder(_ order: HistoryOrder) {
        orders.insert(order, at: 0) // Добавляем в самое начало списка
        saveOrdersToStorage()       // 🌟 Мгновенно синхронизируем изменения с памятью телефона!
    }
    
    private func setupMockData() {
        // Заменили плейсхолдеры <#UUID#> на генерацию реальных UUID()
        orders = [
            HistoryOrder(id: UUID(), wasteType: "Макулатура (бумага)", iconName: "doc.text.fill", iconColorHex: "#007AFF", date: "21 сентября, 18:30", weight: "12 кг", address: "ул. Амира Темура, 14", status: "Выполнено", isCompleted: true),
            HistoryOrder(id: UUID(), wasteType: "Пластик", iconName: "takeoutbag.and.cup.and.straw.fill", iconColorHex: "#F5B61A", date: "14 сентября, 12:00", weight: "5 кг", address: "проспект Навои, 89", status: "Выполнено", isCompleted: true)
        ]
        saveOrdersToStorage() // Фиксируем дефолтный список в памяти первого запуска
    }
    
    // Удаление заказа из памяти устройства
    func deleteOrder(at index: Int) {
        guard index < orders.count else { return }
        orders.remove(at: index)
        saveOrdersToStorage() // Перезаписываем JSON в UserDefaults
    }
    
    //  Обновление параметров существующего заказа (для редактирования и отмены)
    func updateOrder(_ updatedOrder: HistoryOrder) {
        if let index = orders.firstIndex(where: { $0.id == updatedOrder.id }) {
            orders[index] = updatedOrder
            saveOrdersToStorage() // Синхронизируем изменения с памятью телефона
        }
    }
}
