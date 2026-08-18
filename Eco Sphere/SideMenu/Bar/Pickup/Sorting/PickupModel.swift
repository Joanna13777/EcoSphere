import UIKit

// ЕДИНСТВЕННОЕ ГЛОБАЛЬНОЕ ОБЪЯВЛЕНИЕ СТРУКТУРЫ
struct DropDownItem {
    let title: String
    let subtitle: String
    let iconName: String
    let iconColor: UIColor
}

class PickupModelManager {
    
    static let shared = PickupModelManager()
    
    let wasteItems: [DropDownItem] = {
        let opacityGrayColor = UIColor(red: 0.35, green: 0.35, blue: 0.35, alpha: 1.0)
        return [
            DropDownItem(title: "Макулатура (бумага)", subtitle: "картон, втулки, яичные кассеты, книги, тетради, газеты", iconName: "doc.text.fill", iconColor: .systemBlue),
            DropDownItem(title: "Стекло", subtitle: "бутылки, банки для консервации, флаконы от духов", iconName: "wineglass.fill", iconColor: .systemGreen),
            DropDownItem(title: "Пластик", subtitle: "бутылки, крышки, банки, пакеты, посуда, контейнеры", iconName: "capsule.fill", iconColor: UIColor(red: 0.96, green: 0.71, blue: 0.10, alpha: 1.0)),
            DropDownItem(title: "Металл", subtitle: "консервные банки, гвозди, проволока, мет. лом", iconName: "hammer.fill", iconColor: .systemPurple),
            DropDownItem(title: "Органические отходы", subtitle: "Пищевые отходы", iconName: "leaf.fill", iconColor: opacityGrayColor),
            DropDownItem(title: "Электро", subtitle: "Сломанные телефоны, бытовая техника, провода", iconName: "tv.fill", iconColor: .systemGray)
        ]
    }()
    
    private let addressBook: [String: [String]] = [
        "Макулатура (бумага)": ["ул. Амира Темура, 14 (Хаб макулатуры)", "ул. Шота Руставели, 44"],
        "Стекло": ["ул. Катартал, 12 (Прием стеклотары)", "ул. Чиланзарская, 3"],
        "Пластик": ["ул. Амира Темура, 14", "ул. Нукусская, 89 (Пункт переработки ПЭТ)", "проспект Навои, 89"],
        "Металл": ["Малая кольцевая, 6 (Ангар лома)", "ул. Фархадская, 18"],
        "Органические отходы": ["ул. Богишамол, 11 (Компост-центр)", "ул. Саларская, 5"],
        "Электро": ["ул. Нукусская, 44 (Эко-хаб электроники)", "проспект Навои, 89"]
    ]
    
    private init() {}
    
    func getAddresses(for wasteType: String) -> [DropDownItem] {
        let streets = addressBook[wasteType] ?? []
        return streets.map { streetName in
            DropDownItem(
                title: streetName,
                subtitle: "Пункт приема категории: \(wasteType)",
                iconName: "mappin.and.ellipse",
                iconColor: .darkGray
            )
        }
    }
}
