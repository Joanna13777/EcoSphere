import Foundation

struct ArticleItem {
    let title: String
    let previewText: String
    let fullText: String
    let imageName: String? // Для картинок внутри статей
    var isExpanded: Bool = false
}
