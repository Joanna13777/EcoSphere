// Модель данных

import MapKit

class RecyclingPoint: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    let acceptedWasteTypes: [String]
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D, acceptedWasteTypes: [String]) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.acceptedWasteTypes = acceptedWasteTypes
    }
}

// Реализуем Equatable, чтобы метод updateVisiblePoints мог сравнивать точки
extension RecyclingPoint {
    static func == (lhs: RecyclingPoint, rhs: RecyclingPoint) -> Bool {
        return lhs.coordinate.latitude == rhs.coordinate.latitude &&
               lhs.coordinate.longitude == rhs.coordinate.longitude &&
               lhs.title == rhs.title
    }
}
