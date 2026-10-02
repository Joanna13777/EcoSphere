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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIColor.applyGlobalTheme(for: self, withTableView: tableView)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setups
    private func setupNavigationBar() {
        title = "История вывозов"
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .appText
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
 
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryCell")
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableView DataSource & Delegate (Временная заглушка)
extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0 // Пока список пуст, расширим его в следующем шаге
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        return cell
    }
}



// MARK: - Canvas Preview
#Preview {
    let historyVC = HistoryViewController()
    return UINavigationController(rootViewController: historyVC)
}
