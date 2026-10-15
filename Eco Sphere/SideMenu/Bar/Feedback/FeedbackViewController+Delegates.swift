import UIKit

// MARK: - UITextFieldDelegate & UITextViewDelegate для формы обратной связи
extension FeedbackViewController: UITextFieldDelegate, UITextViewDelegate {
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == categoryTextField {
            view.endEditing(true) // Скрываем клавиатуру сообщения, если она была открыта
            
            if isDropDownVisible {
                self.closeDropDownMenuWithAnimation()
            } else {
                self.showCategoryDropDownMenu() // Открываем список тем строго под полем во всю ширину
            }
            return false // Запрещаем стандартный ручной ввод букв с клавиатуры
        }
        return true
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Ваше message..." || textView.text == "Ваше сообщение..." {
            textView.text = ""
            textView.textColor = UIColor.label
        }
        
        if isDropDownVisible {
            self.closeDropDownMenuWithAnimation()
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "Ваше сообщение..."
            textView.textColor = UIColor.placeholderText
        }
        textFieldsChanged()
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        textFieldsChanged()
    }
}

// MARK: - 🌟 ОТРИСОВКА И КЛИКАБЕЛЬНОСТЬ ЯЧЕЕК ВНУТРЕННЕГО ВЫПАДАЮЩЕГО СПИСКА
extension FeedbackViewController: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 // Ровно 5 тем обращений
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicDropdownCell", for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .gray
        
        let topics = ["Вопросы по приложению", "Жалобы и предложения", "Проблема с заказом", "Сотрудничество", "Другое"]
        
        let icons = ["iphone.circle.fill", "text.bubble.fill", "exclamationmark.arrow.triangle.2.circlepath", "hands.sparkles.fill", "ellipsis.bubble.fill"]
        
        var content = cell.defaultContentConfiguration()
        content.text = topics[indexPath.row]
        content.textProperties.font = .systemFont(ofSize: 15, weight: .regular)
        content.textProperties.color = UIColor.appText
        
        content.image = UIImage(systemName: icons[indexPath.row])
        content.imageProperties.tintColor = .systemGray2
        content.imageToTextPadding = 12
        
        cell.contentConfiguration = content
        return cell
    }

    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44 // Идеальная компактная высота строки выпадающего списка
    }
    
    // 🌟 МОМЕНТАЛЬНЫЙ КЛИК ПО ЯЧЕЙКЕ ТЕМЫ!
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let topics = ["Вопросы по приложению", "Жалобы и предложения", "Проблема с заказом", "Сотрудничество", "Другое"]
        let selectedTopic = topics[indexPath.row]
        print("🎯 Пользователь кликнул на тему: \(selectedTopic)")
        
        // 1. Подставляем текст выбранной темы в текстовое поле формы
        categoryTextField.text = selectedTopic
        
        // 2. Анимированно закрываем и удаляем плашку списка с экрана
        self.closeDropDownMenuWithAnimation()
    }
}
