import UIKit

class FeedbackViewController: UIViewController {
    
    // MARK: - Properties
    var categoriesDropDownView: SortingDropDownView?
    var isDropDownVisible = false
    
    // MARK: - UI Elements (Containers)
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.alwaysBounceVertical = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - UI Elements (Input Fields)
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Напишите нам, если у вас возникли вопросы или предложения. Мы обязательно ответим!"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .appSecondaryText
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Поле выбора темы обращения со стрелочкой вниз
    let categoryTextField = FeedbackViewController.createFeedbackTextField(placeholder: "Тема обращения", hasChevron: true)
    
    // Большое поле для ввода текста обращения
    let messageTextView: UITextView = {
        let tv = UITextView()
        tv.text = "Ваше сообщение..."
        tv.textColor = .placeholderText
        tv.font = .systemFont(ofSize: 15)
        tv.backgroundColor = .systemGroupedBackground
        tv.layer.cornerRadius = 12
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.appSeparator.cgColor
        tv.textContainerInset = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 12)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
        // кнопка читает поля categoryTextField и messageTextView напрямую из класса
    let sendButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.background.cornerRadius = 14
        
        var titleAttr = AttributedString("Отправить")
        titleAttr.font = .systemFont(ofSize: 15, weight: .semibold)
        config.attributedTitle = titleAttr
        
        let button = UIButton(configuration: config)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayout() // Вызов из файла +Layout.swift
        setupKeyboardInteractions()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIColor.applyGlobalTheme(for: self)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        // Принудительно обновляем рамку текстового блока
        messageTextView.layer.borderColor = UIColor.appSeparator.cgColor
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Factory Method
    private static func createFeedbackTextField(placeholder: String, hasChevron: Bool = false) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.backgroundColor = .systemGroupedBackground
        tf.font = .systemFont(ofSize: 15)
        tf.layer.cornerRadius = 12
        tf.clearButtonMode = hasChevron ? .never : .whileEditing
        tf.setLeftPadding(16)
        
        if hasChevron {
            let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.down"))
            chevronImageView.tintColor = .systemGray2
            chevronImageView.contentMode = .center
            chevronImageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            tf.rightView = chevronImageView
            tf.rightViewMode = .always
        }
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }
}

// Вспомогательное расширение для безопасного поиска текущего экрана из замыкания кнопки
extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        if let presented = presentedViewController {
            return presented.topMostViewController()
        }
        return self
    }
}
