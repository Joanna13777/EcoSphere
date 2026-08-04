import UIKit

extension String {
    func bolding(_ boldPhrases: [String], normalFont: UIFont, boldFont: UIFont, lineSpacing: CGFloat = 6) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        let fullRange = NSRange(location: 0, length: self.utf16.count)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: fullRange)
        attributedString.addAttribute(.font, value: normalFont, range: fullRange)
        
        let nsString = self as NSString
        
        for phrase in boldPhrases {
            guard !phrase.isEmpty else { continue }
            
            var searchRange = NSRange(location: 0, length: nsString.length)
            
            while searchRange.location < nsString.length {
                // ВОТ ЗДЕСЬ ПРИМЕНЯЕТСЯ ЭТА СТРОКА (добавлена опция .caseInsensitive)
                let foundRange = nsString.range(of: phrase, options: [.caseInsensitive], range: searchRange)
                
                guard foundRange.location != NSNotFound else { break }
                
                attributedString.addAttribute(.font, value: boldFont, range: foundRange)
                
                let newLocation = foundRange.location + foundRange.length
                searchRange = NSRange(location: newLocation, length: nsString.length - newLocation)
            }
        }
        
        return attributedString
    }
}
