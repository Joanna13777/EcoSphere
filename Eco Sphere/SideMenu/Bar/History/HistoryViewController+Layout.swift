import UIKit

// MARK: - Реализация логики и методов Таблицы Истории Вывозов
extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    // 1. Обязательный метод: Количество строк в таблице
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OrderManager.shared.orders.count
    }
    
    // 2. Обязательный метод: Конфигурация ячейки таблицы данными заказа
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as? HistoryOrderCell else {
            return UITableViewCell()
        }
        let order = OrderManager.shared.orders[indexPath.row]
        cell.configure(with: order)
        return cell
    }

    // 3. Дополнительный метод: Удаление заказа свайпом влево
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { _, _, completionHandler in
            // Удаляем из памяти через наш менеджер данных
            OrderManager.shared.deleteOrder(at: indexPath.row)
            // Удаляем строку из таблицы с красивой анимацией исчезновения
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    // 4. Дополнительный метод: Открытие карточки заказа при нажатии на строку списка
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedOrder = OrderManager.shared.orders[indexPath.row]
        let detailVC = OrderDetailViewController(order: selectedOrder)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // 5. Дополнительный метод: Фиксированная высота ячейки истории вывозов
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
}
