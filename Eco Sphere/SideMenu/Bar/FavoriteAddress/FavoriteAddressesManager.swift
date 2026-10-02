import Foundation

class FavoriteAddressesManager {
    static let shared = FavoriteAddressesManager()
    private let storageKey = "user_saved_favorite_addresses"
    
    // Загрузить адреса из памяти устройства
    func loadAddresses() -> [FavoriteAddress] {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let list = try? JSONDecoder().decode([FavoriteAddress].self, from: data) else {
            
            // Если пользователь зашел первый раз и память пуста — возвращаем ваши 3 базовых адреса
            let defaultList = [
                FavoriteAddress(title: "Дом", address: "г. Ташкент, Мирзо-Улугбекский район, ул. Мустакиллик, д. 86", iconName: "house.fill"),
                FavoriteAddress(title: "Работа", address: "г. Ташкент, Юнусабадский район, пр-т Амира Temypa, д. 107B", iconName: "briefcase.fill"),
                FavoriteAddress(title: "Дача", address: "Ташкентская область, Бостанлыкский район, Чарвак", iconName: "leaf.fill")
            ]
            saveAddresses(defaultList) // сразу фиксируем их в памяти
            return defaultList
        }
        return list
    }
    
    // Сохранить обновленный массив адресов в постоянную память
    func saveAddresses(_ list: [FavoriteAddress]) {
        if let encoded = try? JSONEncoder().encode(list) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
}
