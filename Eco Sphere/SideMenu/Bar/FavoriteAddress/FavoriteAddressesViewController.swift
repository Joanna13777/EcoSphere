import UIKit

class FavoriteAddressesViewController: UIViewController {
    
    // Тестовый массив данных
    private var addresses: [FavoriteAddress] = [
        FavoriteAddress(title: "Дом", address: "г. Ташкент, Мирзо-Улугбекский район, ул. Мустакиллик, д. 86", iconName: "house.fill"),
        FavoriteAddress(title: "Работа", address: "г. Ташкент, Юнусабадский район, пр-т Амира Темура, д. 107B", iconName: "briefcase.fill"),
        FavoriteAddress(title: "Дача", address: "Ташкентская область, Бостанлыкский район, Чарвак", iconName: "leaf.fill")
    ]
    
    // MARK: - UI Elements
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.separatorStyle = .none // Убираем стандартные тонкие линии, так как у нас ячейки-карточки
        tv.showsVerticalScrollIndicator = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private let addAddressButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .label // Черная в светлой теме, белая в темной
        config.background.cornerRadius = 14
        
        var titleAttr = AttributedString("Добавить новый адрес")
        titleAttr.font = .systemFont(ofSize: 15, weight: .semibold)
        config.attributedTitle = titleAttr
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        config.image = UIImage(systemName: "plus")?.withConfiguration(imageConfig)
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.baseForegroundColor = .systemBackground
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func addAddressTapped() {
        let addAddressVC = AddAddressViewController()
        addAddressVC.delegate = self // Назначаем текущий экран делегатом
        navigationController?.pushViewController(addAddressVC, animated: true)
    }

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupHierarchy()
        setupLayout()
        setupTableView()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Автоматически красим фон экрана, навигационный бар и таблицу под текущую тему
        UIColor.applyGlobalTheme(for: self, withTableView: tableView)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup Methods
    private func setupNavigationBar() {
        title = "Избранные адреса"
        
        // Кастомная кнопка назад в нашем фирменном адаптивном стиле
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
        view.addSubview(tableView)
        view.addSubview(addAddressButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            // Таблица занимает всё пространство до кнопки внизу
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addAddressButton.topAnchor, constant: -12),
            
            // Фиксированная монолитная кнопка внизу экрана
            addAddressButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addAddressButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addAddressButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addAddressButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        // Регистрируем нашу новую кастомную ячейку
        tableView.register(FavoriteAddressCell.self, forCellReuseIdentifier: "AddressCell")
    }
    
    private func setupActions() {
        addAddressButton.addTarget(self, action: #selector(addAddressTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource & Delegate
extension FavoriteAddressesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! FavoriteAddressCell
        let item = addresses[indexPath.row]
        
        // Передаем данные в ячейку
        cell.configure(title: item.title, address: item.address, iconName: item.iconName)
        
        return cell
    }
    
    // Обработка нажатия на адрес
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Открываем экран в режиме редактирования, передавая текущие данные и индекс строки
        let editAddressVC = AddAddressViewController()
        editAddressVC.delegate = self
        editAddressVC.configureForEditing(address: addresses[indexPath.row], at: indexPath.row)
        
        navigationController?.pushViewController(editAddressVC, animated: true)
    }
    
    // Добавляем возможность удалять адреса свайпом влево (бонус для удобства)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            addresses.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// расширение для обработки данных кнопки "Добавить новый адрес"
// MARK: - AddAddressDelegate
extension FavoriteAddressesViewController: AddAddressDelegate {
    
    func didAddAddress(_ address: FavoriteAddress) {
        addresses.append(address)
        let indexPath = IndexPath(row: addresses.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    // НОВЫЙ МЕТОД: Принимает отредактированный адрес и обновляет конкретную строку таблицы
    func didUpdateAddress(_ address: FavoriteAddress, at index: Int) {
        // Обновляем данные в массиве
        addresses[index] = address
        
        // Плавно перезагружаем только измененную ячейку
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

