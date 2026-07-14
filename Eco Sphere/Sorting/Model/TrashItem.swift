import Foundation

struct TrashItem {
    let name: String         // Название предмета (например, "Глянцевый журнал")
    let category: String     // Категория отходов ("Макулатура", "Пластик", "Опасные отходы")
    let comment: String      // Подсказка ("Снимите пластиковую обложку", "Нельзя бросать в общий бак")
    let isRecyclable: Bool   // Можно ли переработать (true/false)
}
