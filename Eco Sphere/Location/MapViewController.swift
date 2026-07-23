import UIKit
import MapKit

class MapViewController: UIViewController {

    // MARK: - Палитра цветов
    let appBgColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0) // #F5F5F5 (Светло-серый фон приложения)
    let darkTextColor = UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.0) // #1A1A1A (Чистый графитовый черный)
    let secondaryTextColor = UIColor(red: 0.49, green: 0.49, blue: 0.49, alpha: 1.0) // #7E7E7E (Чистый серый)
    let accentYellowColor = UIColor(red: 0.96, green: 0.71, blue: 0.10, alpha: 1.0) // #F4B41A (Фирменный желтый)

    // MARK: - Элементы интерфейса
    let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
        // фон под кнопками и поиском, сделайте bottomContainerView полностью прозрачным
    let bottomContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear // Оставляем прозрачным
        view.layer.cornerRadius = 0
        view.layer.shadowOpacity = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Поиск пунктов..."
        search.backgroundImage = UIImage() // Скрываем серую рамку
        search.backgroundColor = .clear
        
        if let textField = search.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.0) // #F2F2F7
            textField.font = .systemFont(ofSize: 15, weight: .medium)
            textField.textColor = darkTextColor
            textField.layer.cornerRadius = 16
            textField.layer.masksToBounds = true
            
            //Задаем режим отображения крестика через UITextField
                    textField.clearButtonMode = .whileEditing // Крестик будет появляться автоматически при вводе текста
            
            if let leftView = textField.leftView as? UIImageView {
                leftView.tintColor = accentYellowColor
            }
            // Стилизуем системный крестик в цвет вторичного текста
            if let clearButton = textField.value(forKey: "clearButton") as? UIButton {
                let image = clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
                clearButton.setImage(image, for: .normal)
                clearButton.tintColor = secondaryTextColor
            }
        }
        search.returnKeyType = .search
        search.enablesReturnKeyAutomatically = false
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()
    
    // 1. Создаем белую подложку строго для зоны поиска
    private let searchBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white // Настоящий белый фон, скрывающий карту под поиском
        view.layer.cornerRadius = 24  // Красивое скругление сверху подложки
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // Мягкая тень, чтобы плашка красиво отделялась от карты
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.05
        view.layer.shadowOffset = CGSize(width: 0, height: -4)
        view.layer.shadowRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var filterCollectionView: UICollectionView!
    
    // MARK: - Констрейнты и Данные
    var containerBottomConstraint: NSLayoutConstraint!
    
    var allPoints: [RecyclingPoint] = []
    var filteredPoints: [RecyclingPoint] = []
    let filterCategories = ["Все", "Бумага", "Стекло", "Пластик", "Электро", "Органика", "Металл"]
    var selectedCategoryIndex = 0
    var currentSearchText = ""

    // MARK: - Жизненный цикл (Lifecycle)
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Пункты"

        setupMainConfiguration()
        setupCollectionView()
        setupDelegates()
        setupLayout()
        setupMockData()
        setupKeyboardObservers()
        setupGestureToHideKeyboard()

        updateVisiblePoints(animated: false)
        centerMapOnData()
    }
    
    // MARK: - Первичная настройка
    private func setupMainConfiguration() {
        view.backgroundColor = appBgColor
        
        // Создаем кастомную кнопку со стрелкой
            let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(backTapped))
            
            // Красим стрелочку в черный (под ваш стиль)
            backButton.tintColor = .black
            
            // Устанавливаем кнопку слева на верхнем баре
            navigationItem.leftBarButtonItem = backButton
        }

        // Метод, который будет срабатывать при нажатии
        @objc private func backTapped() {
            // Если это Push-переход:
            navigationController?.popViewController(animated: true)
            
            // Или если это Modal-переход:
             dismiss(animated: true, completion: nil)
        
        
        // Прячет текст кнопки назад для всех экранов, открываемых из этого контроллера
            let backButton = UIBarButtonItem()
            backButton.title = ""
            navigationItem.backBarButtonItem = backButton
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
            layout.estimatedItemSize = .zero
            layout.minimumInteritemSpacing = 8
            layout.minimumLineSpacing = 8
        
        
        filterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        filterCollectionView.showsHorizontalScrollIndicator = false
        filterCollectionView.backgroundColor = .clear
        // Включаем нативный скролл и отскок
            filterCollectionView.alwaysBounceHorizontal = true
            filterCollectionView.isScrollEnabled = true
        
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
        // Добавляем белую подложку внутрь bottomContainerView, а поиск — уже внутрь подложки
            bottomContainerView.addSubview(filterCollectionView)
            bottomContainerView.addSubview(searchBackgroundView)
            searchBackgroundView.addSubview(searchBar)
        
        containerBottomConstraint = bottomContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            bottomContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerBottomConstraint,
            
            // Фильтры парят сверху над картой
            filterCollectionView.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 16),
            filterCollectionView.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor),
            filterCollectionView.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor),
            filterCollectionView.heightAnchor.constraint(equalToConstant: 44),
            
            // Белый фон за баром поиска (начинается строго под фильтрами и идет до самого низа)
                    searchBackgroundView.topAnchor.constraint(equalTo: filterCollectionView.bottomAnchor, constant: 12),
                    searchBackgroundView.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor),
                    searchBackgroundView.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor),
                    searchBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor), // Тянем до физического низа экрана, чтобы перекрыть карту полностью
            
            searchBar.topAnchor.constraint(equalTo: filterCollectionView.bottomAnchor, constant: 12),
            searchBar.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -8),
            searchBar.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor, constant: -16)
        ])
    }
    
    // Добавьте эти методы внутрь класса MapViewController в основном файле
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Если нужно скрыть всю верхнюю панель навигации (раскомментируйте строку ниже):
        // navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Возвращаем навигацию обратно при выходе с экрана карты
        // navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}
