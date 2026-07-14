import UIKit
import MapKit

class MapViewController: UIViewController {

    // MARK: - Элементы интерфейса
    let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    let bottomContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Поиск пунктов..."
        search.backgroundImage = UIImage()
        search.searchTextField.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        search.searchTextField.textColor = .black
        search.searchTextField.tintColor = .systemGreen
        search.returnKeyType = .search
        search.enablesReturnKeyAutomatically = false
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()
    
    var filterCollectionView: UICollectionView!
    
    // MARK: - Констрейнты и Данные
    var containerBottomConstraint: NSLayoutConstraint!
    
    var allPoints: [RecyclingPoint] = []
    var filteredPoints: [RecyclingPoint] = []
    let filterCategories = ["Все", "Макулатура", "Стекло", "Пластик", "Электро", "Органика", "Металл"]
    var selectedCategoryIndex = 0
    var currentSearchText = ""

    // MARK: - Жизненный цикл (Lifecycle)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainConfiguration()
        setupCollectionView()
        setupDelegates()
        setupLayout()
        setupMockData() // Метод находится ниже в расширении данных
        setupKeyboardObservers()
        setupGestureToHideKeyboard()
        
        updateVisiblePoints(animated: false)
        centerMapOnData()
    }
    
    // MARK: - Первичная настройка
    private func setupMainConfiguration() {
        view.backgroundColor = .systemBackground
        title = "Пункты"
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = .zero
        
        filterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        filterCollectionView.showsHorizontalScrollIndicator = false
        filterCollectionView.backgroundColor = .clear
        filterCollectionView.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.reuseIdentifier)
        filterCollectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        filterCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupDelegates() {
        mapView.delegate = self
        searchBar.delegate = self
        filterCollectionView.dataSource = self
        filterCollectionView.delegate = self
    }
    
    private func setupLayout() {
        view.addSubview(mapView)
        view.addSubview(bottomContainerView)
        bottomContainerView.addSubview(filterCollectionView)
        bottomContainerView.addSubview(searchBar)
        
        containerBottomConstraint = bottomContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            bottomContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerBottomConstraint,
            
            filterCollectionView.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 12),
            filterCollectionView.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor),
            filterCollectionView.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor),
            filterCollectionView.heightAnchor.constraint(equalToConstant: 80),
            
            searchBar.topAnchor.constraint(equalTo: filterCollectionView.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -8),
            searchBar.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor, constant: -12)
        ])
    }
}
// MARK: - Свайп-бар Фильтров (UICollectionView)
extension MapViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.reuseIdentifier, for: indexPath) as? FilterCell else {
            return UICollectionViewCell()
        }
        
        let text = filterCategories[indexPath.item]
        let isSelected = (indexPath.item == selectedCategoryIndex)
        cell.configure(text: text, isSelected: isSelected)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previousIndex = selectedCategoryIndex
        selectedCategoryIndex = indexPath.item
        
        let indexPathsToReload = [IndexPath(item: previousIndex, section: 0), indexPath].filter { $0.item < filterCategories.count }
        collectionView.reloadItems(at: indexPathsToReload)
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        updateVisiblePoints(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = filterCategories[indexPath.item]
        let font = UIFont.systemFont(ofSize: 12, weight: .bold)
        let attributes: [NSAttributedString.Key : Any] = [.font : font]
        let textWidth = text.size(withAttributes: attributes).width
        
        return CGSize(width: textWidth + 28, height: 34)
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
            annotationView?.markerTintColor = .systemGreen
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
extension MapViewController {
    
    func setupMockData() {
        allPoints = [
            RecyclingPoint(title: "Эко-Пункт Центр", subtitle: "ул. Ленина, 15",
                           coordinate: CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173),
                           acceptedWasteTypes: ["Макулатура", "Пластик", "Стекло"]),
            RecyclingPoint(title: "Сбор Электроники", subtitle: "пр. Мира, 42",
                           coordinate: CLLocationCoordinate2D(latitude: 55.7600, longitude: 37.6300),
                           acceptedWasteTypes: ["Электро", "Металл"]),
            RecyclingPoint(title: "Зеленый Двор", subtitle: "ул. Гагарина, 8",
                           coordinate: CLLocationCoordinate2D(latitude: 55.7450, longitude: 37.6000),
                           acceptedWasteTypes: ["Органика", "Макулатура"]),
            RecyclingPoint(title: "Пункт МеталлЛом", subtitle: "Промзона, к.2",
                           coordinate: CLLocationCoordinate2D(latitude: 55.7700, longitude: 37.5800),
                           acceptedWasteTypes: ["Металл", "Пластик"])
        ]
        filteredPoints = allPoints
    }
    
    func centerMapOnData() {
        guard !allPoints.isEmpty else { return }
        let coordinates = allPoints.map { $0.coordinate }
        let minLat = coordinates.map({ $0.latitude }).min() ?? 0
        let maxLat = coordinates.map({ $0.latitude }).max() ?? 0
        let minLon = coordinates.map({ $0.longitude }).min() ?? 0
        let maxLon = coordinates.map({ $0.longitude }).max() ?? 0
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2, longitude: (minLon + maxLon) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.5 + 0.02, longitudeDelta: (maxLon - minLon) * 1.5 + 0.02)
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
        
        if animated {
            let annotationsToRemove = mapView.annotations.filter { annotation in
                guard let point = annotation as? RecyclingPoint else { return false }
                return !result.contains(point)
            }
            mapView.removeAnnotations(annotationsToRemove)
            
            let currentAnnotations = mapView.annotations.compactMap { $0 as? RecyclingPoint }
            let annotationsToAdd = result.filter { !currentAnnotations.contains($0) }
            mapView.addAnnotations(annotationsToAdd)
        } else {
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotations(result)
        }
        
        filteredPoints = result
    }
}

// MARK: - Системное превью для Canvas
#Preview {
    let vc = MapViewController()
    return UINavigationController(rootViewController: vc)
}
