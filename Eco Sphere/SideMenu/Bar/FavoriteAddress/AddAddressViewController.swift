import UIKit
import MapKit // Добавляем фреймворк для работы с картами
import CoreLocation // Добавляем для распознавания адресов по координатам

protocol AddAddressDelegate: AnyObject {
    func didAddAddress(_ address: FavoriteAddress)
    func didUpdateAddress(_ address: FavoriteAddress, at index: Int)
}

class AddAddressViewController: UIViewController {
    
    weak var delegate: AddAddressDelegate?
    private var editingIndex: Int?
    private var addressToEdit: FavoriteAddress?
    
    // Менеджер для перевода координат в текстовый адрес
    private let geocoder = CLGeocoder()
    
    // MARK: - UI Elements
    private let titleTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Название (например: Дом, Работа)"
        tf.backgroundColor = .systemGroupedBackground
        tf.font = .systemFont(ofSize: 15)
        tf.layer.cornerRadius = 12
        tf.setLeftPadding(16)
        tf.clearButtonMode = .whileEditing
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let addressTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Полный адрес или выберите на карте ниже"
        tf.backgroundColor = .systemGroupedBackground
        tf.font = .systemFont(ofSize: 15)
        tf.layer.cornerRadius = 12
        tf.setLeftPadding(16)
        tf.clearButtonMode = .whileEditing
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    // Карта с адаптивными скруглениями и границами
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.layer.cornerRadius = 16
        map.layer.borderWidth = 1
        map.layer.borderColor = UIColor.appSeparator.cgColor
        map.clipsToBounds = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    private let saveButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .label
        config.background.cornerRadius = 14
        
        var titleAttr = AttributedString("Сохранить адрес")
        titleAttr.font = .systemFont(ofSize: 15, weight: .semibold)
        config.attributedTitle = titleAttr
        config.baseForegroundColor = .systemBackground
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let expandMapButton: UIButton = {
        let button = UIButton(type: .system)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)
        button.setImage(UIImage(systemName: "arrow.up.left.and.arrow.down.right")?.withConfiguration(imageConfig), for: .normal)
        button.tintColor = .appText
        button.backgroundColor = .appCardBackground
        button.layer.cornerRadius = 18
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.appSeparator.cgColor
        
        // Легкая тень для кнопки, чтобы она выделялась на карте
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.15
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupHierarchy()
        setupLayout()
        setupMap()
        setupActions()
        
        titleTextField.addDoneButtonOnKeyboard()
        addressTextField.addDoneButtonOnKeyboard()
        
        if let address = addressToEdit {
            titleTextField.text = address.title
            addressTextField.text = address.address
            title = "Редактировать"
            
            var config = saveButton.configuration
            config?.attributedTitle = AttributedString("Сохранить изменения")
            saveButton.configuration = config
            
            // Если мы редактируем адрес, находим его на карте
            showAddressOnMap(address.address)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIColor.applyGlobalTheme(for: self)
    }
    
    // MARK: - Public Setup
    func configureForEditing(address: FavoriteAddress, at index: Int) {
        self.addressToEdit = address
        self.editingIndex = index
    }
    
    // MARK: - Setup UI & Map
    private func setupNavigationBar() {
        if addressToEdit == nil { title = "Новый адрес" }
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .appText
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func setupHierarchy() {
        view.addSubview(titleTextField)
        view.addSubview(addressTextField)
        view.addSubview(mapView)
        view.addSubview(saveButton)
        
        // Добавляем кнопку поверх карты
        view.addSubview(expandMapButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: 50),
            
            addressTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            addressTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addressTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addressTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Констрейнты для карты (занимает центральную часть экрана)
            mapView.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 16),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mapView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -24),
            // констрейнты для закрепления кнопки в верхнем правом углу карты
            expandMapButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 12),
            expandMapButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -12),
            expandMapButton.widthAnchor.constraint(equalToConstant: 36),
            expandMapButton.heightAnchor.constraint(equalToConstant: 36),
            
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func setupMap() {
        // 1. ЖЕСТКО ЦЕНТРИРУЕМ КАРТУ НА ТАШКЕНТЕ ПРИ ЛЮБОМ ОТКРЫТИИ ЭКРАНА
        let tashkentCenter = CLLocationCoordinate2D(latitude: 41.311081, longitude: 69.240562)
        // 12000 метров — идеальный масштаб, чтобы был виден весь город Ташкент
        let region = MKCoordinateRegion(center: tashkentCenter, latitudinalMeters: 12000, longitudinalMeters: 12000)
        mapView.setRegion(region, animated: false)
        
        // 2. Добавляем жест нажатия для выбора новой точки
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        
        // 3. Отслеживание темы оформления для рамок карты (iOS 17+)
        if #available(iOS 17.0, *) {
            registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (vc: AddAddressViewController, _) in
                vc.mapView.layer.borderColor = UIColor.appSeparator.cgColor
            }
        }
    }

    
    private func setupActions() {
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        // обработка нажатия кнопки «Развернуть» на карте
        expandMapButton.addTarget(self, action: #selector(expandMapTapped), for: .touchUpInside)

    }
    
    // MARK: - Логика Геокодирования (Работа с локациями)
    
    // 1. По нажатию на карту: получаем координаты -> переводим в текст адреса
    @objc private func handleMapTap(_ gesture: UITapGestureRecognizer) {
        let touchPoint = gesture.location(in: mapView)
        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        // Удаляем старые булавки с карты
        mapView.removeAnnotations(mapView.annotations)
        
        // Ставим новую красивую булавку на место нажатия
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        // Запускаем процесс распознавания адреса по координатам
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self, error == nil, let placemark = placemarks?.first else { return }
            
            // Собираем понятную строку адреса
            let city = placemark.locality ?? "Ташкент"
            let street = placemark.thoroughfare ?? ""
            let subThoroughfare = placemark.subThoroughfare ?? "" // номер дома
            
            var fullAddressString = city
            if !street.isEmpty { fullAddressString += ", ул. \(street)" }
            if !subThoroughfare.isEmpty { fullAddressString += ", д. \(subThoroughfare)" }
            
            // Записываем полученный адрес в текстовое поле
            self.addressTextField.text = fullAddressString
        }
    }
    
    // 2. Если адрес уже был: переводим текст в координаты -> фокусируем карту
    private func showAddressOnMap(_ addressText: String) {
        geocoder.geocodeAddressString(addressText) { [weak self] placemarks, error in
            guard let self = self, error == nil,
                  let coordinate = placemarks?.first?.location?.coordinate else { return }
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            self.mapView.addAnnotation(annotation)
            
            // Плавно приближаем карту к конкретному дому (масштаб 800 метров)
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
            self.mapView.setRegion(region, animated: true) // Тут обязательно true
        }
    }

    // MARK: - Actions
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveTapped() {
        guard let name = titleTextField.text, !name.isEmpty,
              let fullAddress = addressTextField.text, !fullAddress.isEmpty else { return }
        let lowercasedName = name.lowercased()
        var icon = "mappin.circle.fill"
        if lowercasedName.contains("дом") { icon = "house.fill" }
        else if lowercasedName.contains("раб") || lowercasedName.contains("офис") { icon = "briefcase.fill" }
        else if lowercasedName.contains("дач") || lowercasedName.contains("чарв") { icon = "leaf.fill" }
        
        let resultAddress = FavoriteAddress(title: name, address: fullAddress, iconName: icon)
        if let index = editingIndex {
            delegate?.didUpdateAddress(resultAddress, at: index)
        } else {
            delegate?.didAddAddress(resultAddress)
        }
        navigationController?.popViewController(animated: true)
    }

@objc private func expandMapTapped() {
    // Берем текущий масштаб маленькой карты, чтобы большая открылась ровно в этом же месте
    let currentRegion = mapView.region
    
    let fullMapVC = FullMapViewController(initialRegion: currentRegion)
    
    // Ловим выбранный адрес из замыкания большой карты
    fullMapVC.onAddressSelected = { [weak self] selectedAddress in
        self?.addressTextField.text = selectedAddress
        // Также дублируем булавочку на маленькую карту
        self?.showAddressOnMap(selectedAddress)
    }
    
    // Оборачиваем в навигационный контроллер для красивого бара со словом "Закрыть"
    let navController = UINavigationController(rootViewController: fullMapVC)
    navController.modalPresentationStyle = .fullScreen // Открываем на весь экран
    present(navController, animated: true, completion: nil)
}
}
