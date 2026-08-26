import UIKit

class ArticleDetailViewController: UIViewController {
    
    var article: ArticleItem?
    
    // MARK: - UI Компоненты
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let articleImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 16
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var noImageBottomConstraint: NSLayoutConstraint!

    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBackground
        setupNavigationBar()
        setupLayout() // Вызовется из +Layout.swift
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        // Считываем и обновляем тему экрана при каждом открытии статьи
        UIColor.applyGlobalTheme(for: self)
        configureData() // Вызовется из +Logic.swift
    }
    
    // MARK: - Настройка навигационной панели
    private func setupNavigationBar() {
        navigationItem.title = ""
        let isDark = UserDefaults.standard.integer(forKey: "selected_app_theme") == 1
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = isDark ? .white : .black
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        let titleLabelButton = UILabel()
        titleLabelButton.text = article?.title ?? ""
        titleLabelButton.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabelButton.textColor = isDark ? .white : .black
        titleLabelButton.numberOfLines = 1
        
        let customNavBarStack = UIStackView(arrangedSubviews: [backButton, titleLabelButton])
        customNavBarStack.axis = .horizontal
        customNavBarStack.spacing = 12
        customNavBarStack.alignment = .center
        
        let leftBarItem = UIBarButtonItem(customView: customNavBarStack)
        navigationItem.leftBarButtonItem = leftBarItem
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}
