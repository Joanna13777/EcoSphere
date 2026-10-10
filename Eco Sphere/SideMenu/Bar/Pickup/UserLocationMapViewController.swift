import UIKit
import MapKit

class UserLocationMapViewController: UIViewController {
    
    var onAddressSelected: ((String) -> Void)?
    private var currentGeocodedAddress = "Определение адреса..."
    private let geocoder = CLGeocoder()
    
    // MARK: - UI Elements
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    private let centerPinImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
        // Подстраиваем под палитру главного экрана: используем accentYellowColor
        iv.tintColor = UIColor(red: 0.96, green: 0.71, blue: 0.10, alpha: 1.0)
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let bottomContainerView: UIView = {
        let view = UIView()
        // Подстраиваем под тему: используем ваш единый цвет карточек
        view.backgroundColor = .appCardBackground
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowOffset = CGSize(width: 0, height: -4)
        view.layer.shadowRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        // Подстраиваем под тему: используем ваш адаптивный текст
        label.textColor = .appText
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Подтвердить адрес", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor(red: 251/255, green: 192/255, blue: 45/255, alpha: 1.0) // Фирменный желтый
        button.tintColor = .black
        button.layer.cornerRadius = 14
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Указать адрес на карте"
        
        setupNavigationBar()
        setupLayout()
        mapView.delegate = self
        
        let initialLocation = CLLocationCoordinate2D(latitude: 41.311081, longitude: 69.240562)
        let region = MKCoordinateRegion(center: initialLocation, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(region, animated: false)
        
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    // 🌟 ПОДСТРОЙКА ПОД ГЛАВНЫЙ ЭКРАН: Внедряем вашу глобальную тему оформления
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIColor.applyGlobalTheme(for: self)
        
        if let navBar = navigationController?.navigationBar {
            let isDark = UserDefaults.standard.integer(forKey: "selected_app_theme") == 1
            let themeColor = UIColor.appBackground
            
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = themeColor
            appearance.titleTextAttributes = [.foregroundColor: isDark ? UIColor.white : UIColor.black]
            
            navBar.standardAppearance = appearance
            navBar.scrollEdgeAppearance = appearance
            navBar.tintColor = isDark ? UIColor.white : UIColor.black
        }
    }
    
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backTapped))
        backButton.tintColor = .appText
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func confirmButtonTapped() {
        self.onAddressSelected?(currentGeocodedAddress)
        navigationController?.popViewController(animated: true)
    }
    
    private func setupLayout() {
        view.addSubview(mapView)
        view.addSubview(centerPinImageView)
        view.addSubview(bottomContainerView)
        bottomContainerView.addSubview(addressLabel)
        bottomContainerView.addSubview(confirmButton)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 20),
            
            centerPinImageView.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            centerPinImageView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor, constant: -12),
            centerPinImageView.widthAnchor.constraint(equalToConstant: 32),
            centerPinImageView.heightAnchor.constraint(equalToConstant: 32),
            
            bottomContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            addressLabel.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 20),
            addressLabel.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 20),
            addressLabel.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -20),
            
            confirmButton.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 16),
            confirmButton.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 20),
            confirmButton.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -20),
            confirmButton.heightAnchor.constraint(equalToConstant: 50),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}

// MARK: - MKMapViewDelegate
extension UserLocationMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let centerCoordinate = mapView.centerCoordinate
        let location = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        
        geocoder.cancelGeocode()
        geocoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "ru_RU")) { [weak self] placemarks, error in
            guard let self = self else { return }
            
            if let placemark = placemarks?.first {
                let street = placemark.thoroughfare ?? ""
                let house = placemark.subThoroughfare ?? ""
                let city = placemark.locality ?? ""
                
                if !street.isEmpty {
                    self.currentGeocodedAddress = "\(street), \(house)".trimmingCharacters(in: .whitespacesAndNewlines)
                    if !city.isEmpty && !self.currentGeocodedAddress.contains(city) {
                        self.currentGeocodedAddress = "\(city), " + self.currentGeocodedAddress
                    }
                } else {
                    self.currentGeocodedAddress = placemark.name ?? "Неизвестный адрес"
                }
            } else {
                self.currentGeocodedAddress = "Адрес не найден"
            }
            
            DispatchQueue.main.async {
                self.addressLabel.text = self.currentGeocodedAddress
            }
        }
    }
}
