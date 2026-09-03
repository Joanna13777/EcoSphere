// работа с делегатами ввода, плейсхолдерами, выпадающим списком категорий и автоподъемом экрана над клавиатурой

import UIKit

// MARK: - Управление выпадающим списком тем
extension FeedbackViewController {
    
    func setupKeyboardInteractions() {
        categoryTextField.addDoneButtonOnKeyboard()
        messageTextView.addDoneButtonOnKeyboard()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAndDropDown))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func dismissKeyboardAndDropDown() {
        view.endEditing(true)
        hideCategoriesDropDown()
    }
    
    func toggleCategoriesDropDown() {
        if isDropDownVisible { hideCategoriesDropDown() } else { showCategoriesDropDown() }
    }
    
    func showCitiesDropDown() {
        showCategoriesDropDown()
    }
    
    func showCategoriesDropDown() {
        guard categoriesDropDownView == nil else { return }
        view.endEditing(true)
        
        let items = [
            DropDownItem(title: "Вопрос по вывозу", subtitle: "График, виды отходов, цены", iconName: "truck.box.fill", iconColor: .appAccent),
            DropDownItem(title: "Проблема с приложением", subtitle: "Баги, ошибки, зависания", iconName: "exclamationmark.triangle.fill", iconColor: .systemRed),
            DropDownItem(title: "Предложение / Отзыв", subtitle: "Как сделать сервис лучше", iconName: "heart.text.square.fill", iconColor: .systemGreen)
        ]
        
        guard !items.isEmpty else { return }
        
        let dropDown = SortingDropDownView(items: items)
        dropDown.translatesAutoresizingMaskIntoConstraints = false
        dropDown.alpha = 0.0
        
        contentView.addSubview(dropDown)
        self.categoriesDropDownView = dropDown
        
        let calculatedHeight = CGFloat(items.count * 64 + 2)
        
        NSLayoutConstraint.activate([
            dropDown.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 4),
            dropDown.leadingAnchor.constraint(equalTo: categoryTextField.leadingAnchor),
            dropDown.trailingAnchor.constraint(equalTo: categoryTextField.trailingAnchor),
            dropDown.heightAnchor.constraint(equalToConstant: calculatedHeight)
        ])
        
        dropDown.onItemSelected = { [weak self] item in
            self?.categoryTextField.text = item.title
            self?.hideCategoriesDropDown()
        }
        
        UIView.animate(withDuration: 0.25) {
            dropDown.alpha = 1.0
            self.isDropDownVisible = true
        }
    }
    
    func hideCategoriesDropDown() {
        guard let dropDown = categoriesDropDownView else { return }
        UIView.animate(withDuration: 0.2, animations: {
            dropDown.alpha = 0.0
        }) { _ in
            dropDown.removeFromSuperview()
            self.categoriesDropDownView = nil
            self.isDropDownVisible = false
        }
    }
}

// MARK: - UITextFieldDelegate & UITextViewDelegate
// MARK: - UITextFieldDelegate & UITextViewDelegate
extension FeedbackViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == categoryTextField {
            toggleCategoriesDropDown()
            return false
        }
        hideCategoriesDropDown()
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        hideCategoriesDropDown()
        if textView.textColor == .placeholderText {
            textView.text = nil
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Ваше сообщение..."
            textView.textColor = .placeholderText
        }
        // Вызываем проверку при завершении редактирования
        textFieldsChanged()
    }
    
    // ДОБАВЛЕНО: Вызывается автоматически при вводе каждого символа в большое текстовое поле
    func textViewDidChange(_ textView: UITextView) {
        textFieldsChanged()
    }
}


// MARK: - Автоподъем экрана при вызове клавиатуры
extension FeedbackViewController {
    
    @objc func keyboardWillShow(notification: NSNotification) {
        hideCategoriesDropDown()
        
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        // 1. Обновляем инсеты скролла
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight + 20, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        // 2. БЕЗОПАСНЫЙ АВТОПОДЪЕМ: Проверяем фреймы на NaN перед скроллом
        if messageTextView.isFirstResponder {
            let rect = contentView.convert(messageTextView.frame, to: scrollView)
            
            // ГЛАВНОЕ ИСПРАВЛЕНИЕ: Проверяем, что координаты являются валидными числами (не NaN и не бесконечность)
            let isRectValid = !rect.origin.x.isNaN && !rect.origin.x.isInfinite &&
                              !rect.origin.y.isNaN && !rect.origin.y.isInfinite &&
                              !rect.size.width.isNaN && !rect.size.width.isInfinite &&
                              !rect.size.height.isNaN && !rect.size.height.isInfinite
            
            // Командуем скроллу только если CoreGraphics гарантированно получит нормальные числа
            if isRectValid {
                scrollView.scrollRectToVisible(rect, animated: true)
            } else {
                print("⚠️ Предотвращен сбой CoreGraphics: rect содержал NaN координаты.")
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        UIView.animate(withDuration: 0.25) {
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
        }
    }
    
    @available(iOS, deprecated: 17.0, message: "Use registerForTraitChanges instead")
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 17.0, *) { return }
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            messageTextView.layer.borderColor = UIColor.appSeparator.cgColor
        }
    }
}
