import UIKit

// MARK: - Действия, Делегаты и Интерактивная Логика Полей
extension PickupViewController: UITextFieldDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setupDelegates() {
        descriptionTextView.delegate = self
        phoneTextField.delegate = self
        weightTextField.delegate = self
        
        wasteTypeTextField.delegate = self
        pickupPointTextField.delegate = self
    }
    
    func setupActions() {
        orderButton.addTarget(self, action: #selector(orderTapped), for: .touchUpInside)
        
        wasteTypeTextField.addTarget(self, action: #selector(wasteTypeFieldTapped), for: .editingDidBegin)
        pickupPointTextField.addTarget(self, action: #selector(pickupPointFieldTapped), for: .editingDidBegin)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func wasteTypeFieldTapped() {
        showCustomDropDown(anchorField: wasteTypeTextField, type: PickupViewController.DropDownType.wasteType)
    }
    
    @objc private func pickupPointFieldTapped() {
        showCustomDropDown(anchorField: pickupPointTextField, type: PickupViewController.DropDownType.pickupPoint)
    }
    
    // --- ИНТЕЛЛЕКТУАЛЬНЫЙ МАСОЧНЫЙ ВВОД ВЕСА ("... кг") ---
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            if textField == weightTextField {
                let currentText = textField.text ?? ""
                let cleanDigits = currentText.replacingOccurrences(of: " кг", with: "").replacingOccurrences(of: " ", with: "")
                if cleanDigits.isEmpty { return false }
                let updatedDigits = String(cleanDigits.dropLast())
                
                if updatedDigits.isEmpty {
                    textField.text = ""
                } else {
                    textField.text = "\(updatedDigits) кг"
                }
                return false
            }
            return true
        }
        
        if textField == wasteTypeTextField || textField == pickupPointTextField {
            return false
        }
        
        if textField == weightTextField {
            let currentText = textField.text ?? ""
            let cleanDigits = currentText.replacingOccurrences(of: " кг", with: "").replacingOccurrences(of: " ", with: "")
            
            guard string.allSatisfy({ $0.isNumber }) else { return false }
            guard cleanDigits.count + string.count <= 5 else { return false }
            
            let newDigits = cleanDigits + string
            textField.text = "\(newDigits) кг"
            return false
        }
        
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == phoneTextField && (textField.text?.isEmpty ?? true) {
            textField.text = "+"
        }
    }
    
    // --- ОФОРМЛЕНИЕ ЗАКАЗА ---
    @objc func orderTapped() {
        view.endEditing(true)
        
        let alert = UIAlertController(title: "Заказать вывоз вторсырья?", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отменить", style: .default, handler: nil)
        let confirmAction = UIAlertAction(title: "Заказать", style: .default) { [weak self] _ in
            self?.showSuccessAlert()
        }
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }
    
    private func showSuccessAlert() {
        let successAlert = UIAlertController(
            title: "Заказ принят  \u{2705}",
            message: "\nОтследить данные можно\nв \"Истории вывозов\"",
            preferredStyle: .alert
        )
        successAlert.addAction(UIAlertAction(title: "ОК", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(successAlert, animated: true)
    }
}

// MARK: - UITextViewDelegate
extension PickupViewController: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Добавить описание" {
            textView.text = ""
            textView.textColor = .black
        }
    }
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Добавить описание"
            textView.textColor = .lightGray
        }
    }
}
