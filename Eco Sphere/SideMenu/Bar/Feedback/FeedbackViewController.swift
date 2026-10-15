import UIKit

class FeedbackViewController: UIViewController {
    
    // MARK: - Properties
    var categoriesDropDownView: UITableView?
    var isDropDownVisible = false
    var selectedImageData: Data? = nil
    
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
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    // Кнопка скрепки или текста "Прикрепить скриншот"
    let attachFileButton: UIButton = {
        let button = UIButton(type: .system)
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "paperclip")
        config.imagePadding = 8
        
        var titleAttr = AttributedString("Прикрепить фото или скриншот")
        titleAttr.font = .systemFont(ofSize: 14, weight: .medium)
        config.attributedTitle = titleAttr
        
        button.configuration = config
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // Маленький ImageView для предпросмотра выбранного изображения
    let previewImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray6
        iv.isHidden = true // Скрыт, пока фото не выбрано
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
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
//        setupKeyboardInteractions()
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
            // Создаем аккуратный квадратный контейнер-подложку для правой части поля
            let chevronContainer = UIView()
            chevronContainer.translatesAutoresizingMaskIntoConstraints = false
            
            let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.down"))
            chevronImageView.tintColor = .systemGray2
            chevronImageView.contentMode = .scaleAspectFit
            chevronImageView.translatesAutoresizingMaskIntoConstraints = false
            
            chevronContainer.addSubview(chevronImageView)
            
            // 🌟 ИСПРАВЛЕНИЕ: Выравниваем шеврон строго по центру вертикали через констрейнты
            NSLayoutConstraint.activate([
                chevronContainer.widthAnchor.constraint(equalToConstant: 44),
                chevronContainer.heightAnchor.constraint(equalToConstant: 44),
                
                chevronImageView.centerYAnchor.constraint(equalTo: chevronContainer.centerYAnchor),
                // Увеличенный отступ от правого края поля (constant: -16)
                chevronImageView.trailingAnchor.constraint(equalTo: chevronContainer.trailingAnchor, constant: -16),
                chevronImageView.widthAnchor.constraint(equalToConstant: 20),
                chevronImageView.heightAnchor.constraint(equalToConstant: 20)
            ])
            
            tf.rightView = chevronContainer
            tf.rightViewMode = .always
        }
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }


}

extension UIViewController {
    var currentNavigationController: UINavigationController? {
        return self.navigationController ?? self.tabBarController?.navigationController
    }
}

