import UIKit

extension ArticleDetailViewController {
    
    func configureData() {
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
        
        let fullRange = NSRange(location: 0, length: finalAttributedString.length)
        finalAttributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: fullRange)
        
        finalAttributedString.addAttribute(
            .foregroundColor,
            value: UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0),
            range: fullRange
        )
        
        textLabel.attributedText = finalAttributedString
        
        // Умное управление отображением картинки
        if let imageName = article.detailImageName, let image = UIImage(named: imageName) {
            articleImageView.image = image
            articleImageView.isHidden = false
            noImageBottomConstraint.priority = .defaultLow // Картинка есть, текст снизу не держит контейнер
        } else {
            articleImageView.image = nil
            articleImageView.isHidden = true
            noImageBottomConstraint.priority = .required // Картинки нет, текст жестко держит дно экрана
        }
    }
}
