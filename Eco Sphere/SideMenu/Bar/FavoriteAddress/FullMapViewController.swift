import UIKit
import MapKit
import CoreLocation

class FullMapViewController: UIViewController {
    
    var onAddressSelected: ((String) -> Void)?
    
    private let geocoder = CLGeocoder()
    private var selectedAddressString: String = ""
    
    // MARK: - UI Elements
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    private let selectButton: UIButton = {
        var config = UIButton.Configuration.filled()
        // ИСПРАВЛЕНО: Привязываем цвета кнопки к глобальной динамической палитре
        config.baseBackgroundColor = UIColor.appText // Станет белой в темной теме, черной в светлой
        config.baseForegroundColor = UIColor.appBackground // Цвет текста инвертируется
        config.background.cornerRadius = 14
        
        var titleAttr = AttributedString("Выбрать этот адрес")
        titleAttr.font = .systemFont(ofSize: 15, weight: .semibold)
        config.attributedTitle = titleAttr
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Init
    init(initialRegion: MKCoordinateRegion) {
        super.init(nibName: nil, bundle: nil)
        mapView.setRegion(initialRegion, animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupHierarchy()
        setupLayout()
        setupMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ГЛАВНОЕ ИСПРАВЛЕНИЕ: Вызываем покраску верхнего навигационного бара под текущую тему приложения
        UIColor.applyGlobalTheme(for: self)
    }
    
    // MARK: - Setup
    private func setupNavigationBar() {
        title = "Выбор на карте"
        
        let closeButton = UIBarButtonItem(
            title: "Закрыть",
            style: .plain,
            target: self,
            action: #selector(closeTapped)
        )
        // ИСПРАВЛЕНО: Цвет кнопки "Закрыть" берется из адаптивного UIColor.appText
        closeButton.tintColor = UIColor.appText
        navigationItem.leftBarButtonItem = closeButton
    }
    
    private func setupHierarchy() {
        view.addSubview(mapView)
        view.addSubview(selectButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            selectButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            selectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            selectButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            selectButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func setupMap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        selectButton.addTarget(self, action: #selector(selectTapped), for: .touchUpInside)
        
        // Отслеживание динамической смены темы (iOS 17+) для кнопки
        if #available(iOS 17.0, *) {
            registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (vc: FullMapViewController, _) in
                vc.updateButtonColors()
            }
        }
    }
    
    // Вспомогательный метод для обновления цветов кнопки принудительно
    private func updateButtonColors() {
        var config = selectButton.configuration
        config?.baseBackgroundColor = UIColor.appText
        config?.baseForegroundColor = UIColor.appBackground
        selectButton.configuration = config
    }
    
    // Обратная совместимость для iOS 16 и ниже
    @available(iOS, deprecated: 17.0, message: "Use registerForTraitChanges instead")
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            
            // На iOS 17+ этот метод ничего делать не будет, управление перейдет к registerForTraitChanges
            if #available(iOS 17.0, *) { return }
            
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                updateButtonColors()
            }
        }
    
    // MARK: - Actions
    @objc private func handleMapTap(_ gesture: UITapGestureRecognizer) {
        let touchPoint = gesture.location(in: mapView)
        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { [weak self] placemarks, error in
            guard let self = self, error == nil, let placemark = placemarks?.first else { return }
            
            let city = placemark.locality ?? "Ташкент"
            let street = placemark.thoroughfare ?? ""
            let house = placemark.subThoroughfare ?? ""
            
            var fullAddress = city
            if !street.isEmpty { fullAddress += ", ул. \(street)" }
            if !house.isEmpty { fullAddress += ", д. \(house)" }
            
            self.selectedAddressString = fullAddress
            self.selectButton.isEnabled = true
            
            var config = self.selectButton.configuration
            config?.subtitle = fullAddress
            
            // Настройка цвета подзаголовка внутри кнопки (серая подпись)
            var subtitleAttributes = AttributeContainer()
            subtitleAttributes.font = .systemFont(ofSize: 12, weight: .regular)
            subtitleAttributes.foregroundColor = traitCollection.userInterfaceStyle == .dark ? .systemGray2 : .darkGray
            config?.attributedSubtitle = AttributedString(fullAddress, attributes: subtitleAttributes)
            
            self.selectButton.configuration = config
        }
    }
    
    @objc private func selectTapped() {
        onAddressSelected?(selectedAddressString)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
}
