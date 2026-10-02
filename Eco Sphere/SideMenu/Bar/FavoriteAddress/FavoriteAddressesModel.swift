
import UIKit

struct FavoriteAddress: Codable { // протокол Codable для сохранения в память телефона
    let title: String
    let address: String
    let iconName: String
}
