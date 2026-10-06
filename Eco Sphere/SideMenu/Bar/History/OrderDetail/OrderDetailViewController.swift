import UIKit

class OrderDetailViewController: UIViewController {
    
    var order: HistoryOrder
    
    // UI-элементы экрана (инициализируются здесь, а верстаются в Layout-файле)
    let containerView = UIView()
    let iconImageView = UIImageView()
    let titleLabel = UILabel()
    let infoLabel = UILabel()
    let statusLabel = UILabel()
    let actionButton = UIButton(type: .system)
    
    init(order: HistoryOrder) {
        self.order = order
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()       // Метод настройки внешнего вида
        setupLayout()   // Наш метод констраинтов из соседнего файла
        updateUIData()  // Наполнение данными
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground // Адаптивный фон iOS
        
        containerView.backgroundColor = .appCardBackground
        containerView.layer.cornerRadius = 16
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .appText
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        infoLabel.numberOfLines = 0
        infoLabel.font = .systemFont(ofSize: 15, weight: .regular)
        infoLabel.textColor = .appSecondaryText
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        statusLabel.font = .systemFont(ofSize: 16, weight: .bold)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        actionButton.layer.cornerRadius = 12
        actionButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func updateUIData() {
        title = "Детали заказа"
        
        // Устанавливаем крупную цветную иконку отхода из модели
        iconImageView.image = UIImage(systemName: order.iconName)
        iconImageView.tintColor = order.iconColor
        
        titleLabel.text = order.wasteType
        
        infoLabel.text = """
        Вес вторсырья:  \(order.weight)
        Дата заказа:      \(order.date)
        Адрес вывоза:    \(order.address)
        """
        
        statusLabel.text = "Статус: \(order.status)"
        
        // Управление доступностью в зависимости от статуса заказа
        if order.status == "Выполнено" || order.status == "Отменен" {
            statusLabel.textColor = order.status == "Выполнено" ? .systemGreen : .systemRed
            actionButton.isHidden = true // Скрываем кнопку, завершенные заказы менять нельзя
        } else {
            statusLabel.textColor = .systemOrange // Статус "В обработке"
            actionButton.isHidden = false
            actionButton.setTitle("Управление заказом", for: .normal)
            actionButton.backgroundColor = UIColor(red: 251/255, green: 192/255, blue: 45/255, alpha: 1.0) // Желтый
            actionButton.tintColor = .black
            actionButton.addTarget(self, action: #selector(manageOrderTapped), for: .touchUpInside)
        }
    }
    
    @objc private func manageOrderTapped() {
        let actionSheet = UIAlertController(title: "Управление заказом", message: "Выберите действие", preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "Редактировать данные", style: .default) { [weak self] _ in
            self?.showEditDialog()
        }
        
        let cancelOrderAction = UIAlertAction(title: "Отменить заказ", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.order.status = "Отменен"
            self.order.isCompleted = true
            OrderManager.shared.updateOrder(self.order) // Сохраняем в UserDefaults
            self.updateUIData()
        }
        
        actionSheet.addAction(editAction)
        actionSheet.addAction(cancelOrderAction)
        actionSheet.addAction(UIAlertAction(title: "Назад", style: .cancel))
        present(actionSheet, animated: true)
    }
    
    private func showEditDialog() {
        let alert = UIAlertController(title: "Редактирование", message: "Измените параметры заказа", preferredStyle: .alert)
        
        alert.addTextField { $0.placeholder = "Вес (например: 10 кг)"; $0.text = self.order.weight }
        alert.addTextField { $0.placeholder = "Дата вывоза"; $0.text = self.order.date }
        alert.addTextField { $0.placeholder = "Адрес вывоза"; $0.text = self.order.address }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            guard let self = self, let fields = alert.textFields,
                  let newWeight = fields[0].text, !newWeight.isEmpty,
                  let newDate = fields[1].text, !newDate.isEmpty,
                  let newAddress = fields[2].text, !newAddress.isEmpty else { return }
            
            self.order.weight = newWeight
            self.order.date = newDate
            self.order.address = newAddress
            
            OrderManager.shared.updateOrder(self.order) // Фиксируем изменения в памяти телефона
            self.updateUIData()
        }
        
        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }
}
