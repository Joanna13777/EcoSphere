import UIKit

class NotificationCenterViewController: UIViewController {
    
    var notifications: [AppNotification] = []
    
    // MARK: - UI Elements
    let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped) // Карточки в стиле системных настроек iOS
        tv.separatorStyle = .singleLine
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let emptyStateView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let iv = UIImageView(image: UIImage(systemName: "bell.slash.fill"))
        iv.tintColor = .systemGray4
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "Уведомлений пока нет"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(iv)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            iv.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iv.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            iv.widthAnchor.constraint(equalToConstant: 64),
            iv.heightAnchor.constraint(equalToConstant: 64),
            
            label.topAnchor.constraint(equalTo: iv.bottomAnchor, constant: 12),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayout()
        setupTableView()
        loadNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIColor.applyGlobalTheme(for: self, withTableView: tableView)
        
        // Как только экран открылся, помечаем уведомления как ПРОЧИТАННЫЕ
                NotificationManager.shared.setHasUnread(false)
    }
    
    private func setupNavigationBar() {
        title = "Уведомления"
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .appText
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let clearButton = UIBarButtonItem(title: "Очистить", style: .plain, target: self, action: #selector(clearAllTapped))
        clearButton.tintColor = .systemRed
        navigationItem.rightBarButtonItem = clearButton
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(emptyStateView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NotificationCell.self, forCellReuseIdentifier: "NotificationCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 90
    }
    
    func loadNotifications() {
        notifications = NotificationManager.shared.getNotifications()
        tableView.isHidden = notifications.isEmpty
        emptyStateView.isHidden = !notifications.isEmpty
        navigationItem.rightBarButtonItem?.isEnabled = !notifications.isEmpty
        tableView.reloadData()
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func clearAllTapped() {
        let alert = UIAlertController(title: "Очистить историю?", message: "Вы уверены, что хотите удалить все уведомления?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { [weak self] _ in
            NotificationManager.shared.clearAll()
            self?.loadNotifications()
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - UITableView DataSource & Delegate
extension NotificationCenterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        let item = notifications[indexPath.row]
        cell.configure(with: item)
        return cell
    }
}

// MARK: - КАСТОМНАЯ ЯЧЕЙКА УВЕДОМЛЕНИЯ
class NotificationCell: UITableViewCell {
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .light)
        label.textColor = .placeholderText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .secondarySystemGroupedBackground
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(bodyLabel)
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            
            bodyLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 6),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(with item: AppNotification) {
        titleLabel.text = item.title
        bodyLabel.text = item.body
        dateLabel.text = item.dateString
        
        switch item.type {
        case .security:
            iconImageView.image = UIImage(systemName: "lock.shield.fill")
            iconImageView.tintColor = .systemOrange
        case .agreement:
            iconImageView.image = UIImage(systemName: "checkmark.shield.fill")
            iconImageView.tintColor = .systemBlue
        case .ecoBonus:
            iconImageView.image = UIImage(systemName: "leaf.circle.fill")
            iconImageView.tintColor = .systemGreen
        case .pickup:
            iconImageView.image = UIImage(systemName: "truck.box.fill")
            iconImageView.tintColor = .label
        }
    }
}
