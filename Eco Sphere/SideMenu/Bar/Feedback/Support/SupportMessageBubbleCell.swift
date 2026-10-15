import UIKit

// MARK: - КАСТОМНАЯ ЯЧЕЙКА ПУЗЫРЬКА СООБЩЕНИЯ
class SupportMessageBubbleCell: UITableViewCell {
    
    private let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let attachedImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        iv.isHidden = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?
    private var imageHiddenConstraint: NSLayoutConstraint?
    private var imageVisibleConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(attachedImageView)
        bubbleView.addSubview(messageLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        leadingConstraint = bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        trailingConstraint = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            bubbleView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.75),
            
            attachedImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 8),
            attachedImageView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
            attachedImageView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),
            attachedImageView.widthAnchor.constraint(equalToConstant: 200),
            attachedImageView.heightAnchor.constraint(equalToConstant: 150),
        ])
        
        imageHiddenConstraint = messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 10)
        imageVisibleConstraint = messageLabel.topAnchor.constraint(equalTo: attachedImageView.bottomAnchor, constant: 8)
        
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 14),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -14),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with message: SupportMessage) {
        messageLabel.text = message.text
        
        if let data = message.attachedImageData, let image = UIImage(data: data) {
            attachedImageView.image = image
            attachedImageView.isHidden = false
            imageHiddenConstraint?.isActive = false
            imageVisibleConstraint?.isActive = true
        } else {
            attachedImageView.isHidden = true
            imageVisibleConstraint?.isActive = false
            imageHiddenConstraint?.isActive = true
        }
        
        if message.sender == .user {
            bubbleView.backgroundColor = .systemBlue
            messageLabel.textColor = .white
            leadingConstraint?.isActive = false
            trailingConstraint?.isActive = true
            bubbleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        } else {
            bubbleView.backgroundColor = .secondarySystemGroupedBackground
            messageLabel.textColor = .label
            trailingConstraint?.isActive = false
            leadingConstraint?.isActive = true
            bubbleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
    }
}
