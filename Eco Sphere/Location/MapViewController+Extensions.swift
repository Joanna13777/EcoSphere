import UIKit
import MapKit

// MARK: - Свайп-бар Фильтров (UICollectionView)
extension MapViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterCategories.count
    }
    // ВНУТРИ ФАЙЛА MapViewController+Extensions.swift
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // ЗАЩИТА 1: Проверяем, что индекс физически существует в массиве категорий карты
        guard indexPath.item >= 0 && indexPath.item < filterCategories.count else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.reuseIdentifier, for: indexPath)
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.reuseIdentifier, for: indexPath) as? FilterCell else {
            return UICollectionViewCell()
        }
        
        let text = filterCategories[indexPath.item]
        let isSelected = (indexPath.item == selectedCategoryIndex)
        cell.configure(text: text, isSelected: isSelected)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // ЗАЩИТА 2: Проверяем индекс при нажатии на кнопку фильтра
        guard indexPath.item >= 0 && indexPath.item < filterCategories.count else { return }
        
        let previousIndex = selectedCategoryIndex
        selectedCategoryIndex = indexPath.item
        
        // Перерисовываем только те ячейки, которые гарантированно существуют в массиве
        let indexPathsToReload = [IndexPath(item: previousIndex, section: 0), indexPath].filter { $0.item >= 0 && $0.item < filterCategories.count }
        collectionView.reloadItems(at: indexPathsToReload)
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        updateVisiblePoints(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // ЗАЩИТА 3: Проверяем индекс при расчете размера ячеек
        guard indexPath.item >= 0 && indexPath.item < filterCategories.count else {
            return CGSize(width: 60, height: 38)
        }
        
        let text = filterCategories[indexPath.item]
        let font = UIFont.systemFont(ofSize: 14, weight: .medium)
        let attributes: [NSAttributedString.Key : Any] = [.font : font]
        let textWidth = text.size(withAttributes: attributes).width
        
        return CGSize(width: textWidth + 36, height: 38)
    }
}

// MARK: - Поисковая строка (UISearchBarDelegate)
extension MapViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentSearchText = searchText
        updateVisiblePoints(animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    // ВНУТРИ ФАЙЛА MapViewController+Extensions.swift в расширении UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        currentSearchText = ""
        updateVisiblePoints(animated: true)
        searchBar.resignFirstResponder()
    }

}

// MARK: - Интерактивная Карта (MKMapViewDelegate)
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is RecyclingPoint else { return nil }
        
        let identifier = "RecyclePointMarker"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.glyphImage = UIImage(systemName: "arrow.3.trianglepath")
            annotationView?.markerTintColor = .systemRed
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        for view in views {
            view.alpha = 0
            view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                view.alpha = 1
                view.transform = .identity
            }, completion: nil)
        }
    }
}

// MARK: - Управление клавиатурой и Жесты
extension MapViewController {
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 0
            
            containerBottomConstraint.constant = -(keyboardHeight - tabBarHeight)
            animateLayoutChanges()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        containerBottomConstraint.constant = 0
        animateLayoutChanges()
    }
    
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    private func animateLayoutChanges() {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Работа с Данными и Логика Фильтрации
// ВНУТРИ ФАЙЛА MapViewController+Extensions.swift

// MARK: - Работа с Данными и Логика Фильтрации (Локализация: Ташкент)
extension MapViewController {
    
    func setupMockData() {
        allPoints = [
            RecyclingPoint(title: "Эко-Пункт ЦУМ",
                           subtitle: "Мирабадский р-н, ул. Шахрисабз, 5",
                           coordinate: CLLocationCoordinate2D(latitude: 41.3101, longitude: 69.2715),
                           acceptedWasteTypes: ["Макулатура", "Пластик", "Стекло"]),
            
            RecyclingPoint(title: "Сбор Электроники Чиланзар",
                           subtitle: "Чиланзарский р-н, квартал-1, 42",
                           coordinate: CLLocationCoordinate2D(latitude: 41.2855, longitude: 69.2045),
                           acceptedWasteTypes: ["Электро", "Металл"]),
            
            RecyclingPoint(title: "Зеленый Двор Экопарк",
                           subtitle: "Яшнабадский р-н, ул. Махтумкули",
                           coordinate: CLLocationCoordinate2D(latitude: 41.3125, longitude: 69.2950),
                           acceptedWasteTypes: ["Органика", "Макулатура"]),
            
            RecyclingPoint(title: "Пункт Сбора Юнусабад",
                           subtitle: "Юнусабадский р-н, Квартал-4, к.2",
                           coordinate: CLLocationCoordinate2D(latitude: 41.3530, longitude: 69.2880),
                           acceptedWasteTypes: ["Металл", "Пластик"])
        ]
        filteredPoints = allPoints
    }
    
    func centerMapOnData() {
        guard !allPoints.isEmpty else { return }
        let coordinates = allPoints.map { $0.coordinate }
        let minLat = coordinates.map({ $0.latitude }).min() ?? 41.3110
        let maxLat = coordinates.map({ $0.latitude }).max() ?? 41.3110
        let minLon = coordinates.map({ $0.longitude }).min() ?? 69.2405
        let maxLon = coordinates.map({ $0.longitude }).max() ?? 69.2405
        
        // Математический центр Ташкента на основе наших точек
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
        
        // Оптимальный масштаб отображения города
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.8 + 0.05,
                                    longitudeDelta: (maxLon - minLon) * 1.8 + 0.05)
        
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func updateVisiblePoints(animated: Bool) {
        let activeCategory = filterCategories[selectedCategoryIndex]
        var result = allPoints
        
        if activeCategory != "Все" {
            result = allPoints.filter { $0.acceptedWasteTypes.contains(activeCategory) }
        }
        
        if !currentSearchText.isEmpty {
            result = result.filter { point in
                let titleMatch = point.title?.localizedCaseInsensitiveContains(currentSearchText) ?? false
                let subtitleMatch = point.subtitle?.localizedCaseInsensitiveContains(currentSearchText) ?? false
                return titleMatch || subtitleMatch
            }
        }
        
        filteredPoints = result
        
        let currentAnnotations = mapView.annotations.compactMap { $0 as? RecyclingPoint }
        
        let toRemove = currentAnnotations.filter { !filteredPoints.contains($0) }
        let toAdd = filteredPoints.filter { !currentAnnotations.contains($0) }
        
        if animated {
            mapView.removeAnnotations(toRemove)
            mapView.addAnnotations(toAdd)
        } else {
            mapView.removeAnnotations(currentAnnotations)
            mapView.addAnnotations(filteredPoints)
        }
    }
}
