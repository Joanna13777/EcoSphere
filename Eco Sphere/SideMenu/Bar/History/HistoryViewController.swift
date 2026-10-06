
import UIKit

class HistoryViewController: UIViewController {
    
    // MARK: - UI Elements
    let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayout() 
        setupTableView()
        
        navigationItem.backButtonDisplayMode = .minimal
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIColor.applyGlobalTheme(for: self, withTableView: tableView)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        // Перезагружаем таблицу, чтобы увидеть свежие изменения и новые заказы
        self.tableView.reloadData()
    }
    
    // MARK: - Setups
    private func setupNavigationBar() {
        title = "История"
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .appText
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func setupLayout() {
           view.addSubview(tableView)
           NSLayoutConstraint.activate([
               tableView.topAnchor.constraint(equalTo: view.topAnchor),
               tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
           ])
       }
    
    private func setupTableView() {
            tableView.delegate = self
            tableView.dataSource = self
            // Регистрируем ПРАВИЛЬНЫЙ класс ячейки (HistoryOrderCell)
            tableView.register(HistoryOrderCell.self, forCellReuseIdentifier: "HistoryCell")
        }
 
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Canvas Preview
#Preview {
    let historyVC = HistoryViewController()
    return UINavigationController(rootViewController: historyVC)
}
