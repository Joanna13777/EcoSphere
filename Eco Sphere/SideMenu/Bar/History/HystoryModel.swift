import UIKit

// MARK: - Структура данных заказа с поддержкой сохранения
struct HistoryOrder: Codable {
    let id: UUID // Уникальный ID для точного поиска заказа при изменении/удалении
    let wasteType: String
    let iconName: String
    let iconColorHex: String
    var date: String      // Сделали var, чтобы можно было редактировать
    var weight: String    // Сделали var, чтобы можно было редактировать
    var address: String   // Сделали var, чтобы можно было редактировать
    var status: String    // Сделали var, чтобы менять на "Отменен"
    var isCompleted: Bool
    
    var iconColor: UIColor {
        return UIColor(hex: iconColorHex) ?? .systemGreen
    }
}

// MARK: - Вспомогательное расширение для работы с HEX-цветами
extension UIColor {
    convenience init?(hex: String) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") { cString.remove(at: cString.startIndex) }
        if cString.count != 6 { return nil }
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
    
    var toHexString: String {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format: "#%06x", rgb)
    }
}
