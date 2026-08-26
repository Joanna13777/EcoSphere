import UIKit

        // MARK: - Чистая Inline-верстка (Auto Layout)
extension PickupViewController {
    
    func setupLayout() {
        // 1. СНАЧАЛА добавляем все базовые элементы на экран в строгом порядке
        view.addSubview(wasteTypeTextField)
        view.addSubview(pickupPointTextField)
        view.addSubview(weightTextField)
        
        view.addSubview(dateBorderView)
        view.addSubview(timeBorderView)
        
        view.addSubview(sortingReminderView)
        view.addSubview(descriptionTextView)
        view.addSubview(orderButton)
        
        // Настраиваем рамки карточек под текущую тему (используем наш умный appSeparator)
        dateBorderView.layer.borderColor = UIColor.appSeparator.cgColor
        timeBorderView.layer.borderColor = UIColor.appSeparator.cgColor
        
        // Делаем фоны карточек даты/времени адаптивными
        dateBorderView.backgroundColor = .appCardBackground
        timeBorderView.backgroundColor = .appCardBackground
        
        // Переводим фоны текстовых полей на системный цвет (они сами станут темно-серыми в темной теме)
        let fields = [wasteTypeTextField, pickupPointTextField, weightTextField, nameTextField, phoneTextField, addressTextField]
        fields.forEach { tf in
            tf.backgroundColor = .systemGroupedBackground
        }
        
        // 2. Собираем контент внутрь рамки ДАТЫ
        dateBorderView.addSubview(dateTitleLabel)
        dateBorderView.addSubview(inlineDatePicker)
        
        // 3. Собираем контент внутрь рамки ВРЕМЕНИ
        timeBorderView.addSubview(timeTitleLabel)
        
        // Создаем стек для плашек времени (перенесли сюда, чтобы констрейнты ниже его видели)
        let timePickersStack = UIStackView(arrangedSubviews: [startTimePicker, endTimePicker])
        timePickersStack.axis = .horizontal
        timePickersStack.spacing = 8
        timePickersStack.alignment = .center
        timePickersStack.distribution = .fillEqually
        timePickersStack.translatesAutoresizingMaskIntoConstraints = false
        timeBorderView.addSubview(timePickersStack)
        
        // 4. Базовые констрейнты для верхних полей
        NSLayoutConstraint.activate([
            wasteTypeTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            wasteTypeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            wasteTypeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            wasteTypeTextField.heightAnchor.constraint(equalToConstant: 48),
            
            pickupPointTextField.topAnchor.constraint(equalTo: wasteTypeTextField.bottomAnchor, constant: 12),
            pickupPointTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pickupPointTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pickupPointTextField.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        // 5. Динамический сдвиг интерфейса в зависимости от статуса авторизации пользователя
        if isLoggedIn {
            NSLayoutConstraint.activate([
                weightTextField.topAnchor.constraint(equalTo: pickupPointTextField.bottomAnchor, constant: 12),
                weightTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                weightTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                weightTextField.heightAnchor.constraint(equalToConstant: 48),
                
                dateBorderView.topAnchor.constraint(equalTo: weightTextField.bottomAnchor, constant: 16)
            ])
        } else {
            // Если гость — сначала добавляем поля ФИО, Телефона и Адреса на вью
            view.addSubview(nameTextField)
            view.addSubview(phoneTextField)
            view.addSubview(addressTextField)
            
            NSLayoutConstraint.activate([
                nameTextField.topAnchor.constraint(equalTo: pickupPointTextField.bottomAnchor, constant: 12),
                nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                nameTextField.heightAnchor.constraint(equalToConstant: 48),
                
                phoneTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 12),
                phoneTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                phoneTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                phoneTextField.heightAnchor.constraint(equalToConstant: 48),
                
                addressTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 12),
                addressTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                addressTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                addressTextField.heightAnchor.constraint(equalToConstant: 48),
                
                weightTextField.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 12),
                weightTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                weightTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                weightTextField.heightAnchor.constraint(equalToConstant: 48),
                
                dateBorderView.topAnchor.constraint(equalTo: weightTextField.bottomAnchor, constant: 16)
            ])
        }
        
        // 6. Констрейнты для блоков ДАТЫ, ВРЕМЕНИ, НАПОМИНАЛКИ и кнопки ЗАКАЗА
        NSLayoutConstraint.activate([
            dateBorderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateBorderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dateBorderView.heightAnchor.constraint(equalToConstant: 52),
            
            dateTitleLabel.leadingAnchor.constraint(equalTo: dateBorderView.leadingAnchor, constant: 16),
            dateTitleLabel.centerYAnchor.constraint(equalTo: dateBorderView.centerYAnchor),
            
            inlineDatePicker.trailingAnchor.constraint(equalTo: dateBorderView.trailingAnchor, constant: -12),
            inlineDatePicker.centerYAnchor.constraint(equalTo: dateBorderView.centerYAnchor),
            
            timeBorderView.topAnchor.constraint(equalTo: dateBorderView.bottomAnchor, constant: 16),
            timeBorderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            timeBorderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            timeBorderView.heightAnchor.constraint(equalToConstant: 52),
            
            timeTitleLabel.leadingAnchor.constraint(equalTo: timeBorderView.leadingAnchor, constant: 16),
            timeTitleLabel.centerYAnchor.constraint(equalTo: timeBorderView.centerYAnchor),
            timeTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: timePickersStack.leadingAnchor, constant: -8),
            
            timePickersStack.trailingAnchor.constraint(equalTo: timeBorderView.trailingAnchor, constant: -12),
            timePickersStack.centerYAnchor.constraint(equalTo: timeBorderView.centerYAnchor),
            
            // Карточка-напоминание теперь красиво выезжает под блоком времени
            sortingReminderView.topAnchor.constraint(equalTo: timeBorderView.bottomAnchor, constant: 16),
            sortingReminderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sortingReminderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Поле описания плавно опускается ниже карточки-напоминания
            descriptionTextView.topAnchor.constraint(equalTo: sortingReminderView.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 80),
            
            // Фирменная монолитная кнопка заказа зафиксирована в самом низу
            orderButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            orderButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            orderButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            orderButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
}
