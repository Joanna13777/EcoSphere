import UIKit

class ArticleDetailViewController: UIViewController {
    
    var article: ArticleItem?
    
    // MARK: - UI Элементы
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false // Запрещаем редактирование
        tv.isScrollEnabled = false // Выключаем внутренний скролл, так как у нас есть UIScrollView
        tv.textContainerInset = .zero // Убираем внутренние отступы, чтобы текст не съезжал
        tv.textContainer.lineFragmentPadding = 0 // Убираем боковые микро-поля
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    
    private let articleImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 16
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupLayout()
        configureData()
    }
    
    
    
    private func setupNavigationBar() {
        navigationItem.title = ""
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        let titleLabelButton = UILabel()
        titleLabelButton.text = article?.title ?? ""
        titleLabelButton.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabelButton.textColor = .black
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
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(textView)
        contentView.addSubview(articleImageView)
        
        // Фиксируем высоту картинки внизу
        let imageHeight = articleImageView.heightAnchor.constraint(equalToConstant: 180)
        imageHeight.priority = .defaultHigh
        imageHeight.isActive = true
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Текст статьи теперь идет на самом верху контента
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Картинка размещается строго ПОД текстом статьи
            articleImageView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20),
            articleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            articleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            articleImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    private func configureData() {
        guard let article = article else { return }
        
        let regularFont = UIFont.systemFont(ofSize: 15, weight: .regular)
        let boldFont = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        let formattedString = article.fullText.bolding(
            article.boldPhrases,
            normalFont: regularFont,
            boldFont: boldFont,
            lineSpacing: 6
        )
        
        let finalAttributedString = NSMutableAttributedString(attributedString: formattedString)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = .left
        
        // Включаем перенос по слогам на максимум (1.0)
        paragraphStyle.hyphenationFactor = 1.0
        
        let fullRange = NSRange(location: 0, length: finalAttributedString.length)
        finalAttributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: fullRange)
        finalAttributedString.addAttribute(
            .foregroundColor,
            value: UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0),
            range: fullRange
        )
        
        // Присваиваем текст нашему новому тексту
        textView.attributedText = finalAttributedString
        
        if let imageName = article.detailImageName, let image = UIImage(named: imageName) {
            articleImageView.image = image
            articleImageView.isHidden = false
        } else {
            articleImageView.image = nil
            articleImageView.isHidden = true
            // Поменяли на textView
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30).isActive = true
        }
    }


}
