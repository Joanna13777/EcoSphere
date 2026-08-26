import Foundation

struct TrashItem {
    let name: String         // Название предмета (например, "Глянцевый журнал")
    let category: String     // Категория отходов ("Бумага", "Пластик")
    let comment: String      // Подсказка ("Снимите пластиковую обложку")
    let isRecyclable: Bool   // Можно ли переработать (true/false)
}
