import UIKit

class SupportChatListViewController: UIViewController {
    
    private var currentSort: SupportSortCriterion = .dateNewest
    
    // MARK: - UI Elements
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.separatorStyle = .singleLine
        tv.separatorColor = UIColor.appSeparator
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private let createNewRequestButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать новое обращение", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = UIColor.appAccent
        button.tintColor = .black
        button.layer.cornerRadius = 14
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Чат с поддержкой"
        view.backgroundColor = UIColor.appBackground
        
        setupNavigationBar()
        setupLayout()
        setupTableView()
        
        createNewRequestButton.addTarget(self, action: #selector(createNewRequestTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIColor.applyGlobalTheme(for: self)
        view.backgroundColor = UIColor.appBackground
        tableView.reloadData()
    }
    
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backTapped)
        )
        backButton.tintColor = UIColor.appText
        navigationItem.leftBarButtonItem = backButton
        
        let sortButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.up.and.down.text.horizontal"),
            style: .plain,
            target: self,
            action: #selector(sortTapped)
        )
        sortButton.tintColor = UIColor.appText
        navigationItem.rightBarButtonItem = sortButton
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func createNewRequestTapped() {
        let feedbackVC = FeedbackViewController()
        navigationController?.pushViewController(feedbackVC, animated: true)
    }
    
    @objc private func sortTapped() {
        let alert = UIAlertController(title: "Сортировка чатов", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Сначала новые", style: .default) { [weak self] _ in
            self?.currentSort = .dateNewest
            self?.tableView.reloadData()
        })
        alert.addAction(UIAlertAction(title: "Сначала старые", style: .default) { [weak self] _ in
            self?.currentSort = .dateOldest
            self?.tableView.reloadData()
        })
        alert.addAction(UIAlertAction(title: "По теме обращения", style: .default) { [weak self] _ in
            self?.currentSort = .category
            self?.tableView.reloadData()
        })
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(createNewRequestButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: createNewRequestButton.topAnchor, constant: -16),
            
            createNewRequestButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createNewRequestButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createNewRequestButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createNewRequestButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FeedbackChatCell.self, forCellReuseIdentifier: "ChatCell")
    }
}

// MARK: - UITableView Блок Данных
extension SupportChatListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // 🌟 ИСПРАВЛЕНИЕ: Считаем количество элементов в актуальном отсортированном списке
        let count = SupportChatManager.shared.getSortedRequests(by: currentSort).count
        return "Архивные обращения: \(count)"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.appSecondaryText
        header.textLabel?.font = .systemFont(ofSize: 13, weight: .regular)
        header.contentView.backgroundColor = UIColor.appBackground
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 🌟 ИСПРАВЛЕНИЕ: Количество строк должно строго совпадать с отсортированным массивом
        return SupportChatManager.shared.getSortedRequests(by: currentSort).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as? FeedbackChatCell else {
            return UITableViewCell()
        }
        let request = SupportChatManager.shared.getSortedRequests(by: currentSort)[indexPath.row]
        cell.configure(with: request)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, completionHandler in
            guard let self = self else {
                completionHandler(false)
                return
            }
            
            // Получаем актуальный отсортированный список и находим ID нужного элемента
            let sortedRequests = SupportChatManager.shared.getSortedRequests(by: self.currentSort)
            let requestToDelete = sortedRequests[indexPath.row]
            
            // Передаем UUID вместо Int индекса
            SupportChatManager.shared.deleteRequest(id: requestToDelete.id)
            
            // Анимированно удаляем строку
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // обновляем текст заголовка секции, чтобы цифра уменьшилась в реальном времени
            if let headerView = tableView.headerView(forSection: indexPath.section) {
                headerView.textLabel?.text = self.tableView(tableView, titleForHeaderInSection: indexPath.section)
                headerView.setNeedsLayout()
            }
            
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Берем массив напрямую из менеджера по текущему критерию сортировки
        let sortedRequests = SupportChatManager.shared.getSortedRequests(by: self.currentSort)
        let selectedRequest = sortedRequests[indexPath.row]
        
        // Открываем экран детальной переписки (чат)
        let chatDetailsVC = SupportChatDetailsViewController(request: selectedRequest)
        navigationController?.pushViewController(chatDetailsVC, animated: true)
    }
}
