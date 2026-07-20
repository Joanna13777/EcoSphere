import UIKit

// MARK: - UITableViewDataSource
extension SortingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredItems.count : articlesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearching {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrashCell", for: indexPath) as! CustomTrashCell
            let item = filteredItems[indexPath.row]
            cell.configure(with: item)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleTableViewCell
            let article = articlesData[indexPath.row]
            cell.configure(with: article)
            
            // Нажатие на зеленую кнопку "далее"
            cell.onMoreButtonTapped = { [weak self] in
                let detailVC = ArticleDetailViewController()
                detailVC.article = article
                self?.navigationController?.pushViewController(detailVC, animated: true)
            }
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension SortingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return isSearching ? 88 : 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if isSearching {
            let item = filteredItems[indexPath.row]
            print("Нажата карточка отходов: \(item.name)")
        } else {
            // Анимация плавного аккордеона (раскрытия ячейки)
            articlesData[indexPath.row].isExpanded.toggle()
            
            tableView.performBatchUpdates({
                tableView.reloadRows(at: [indexPath], with: .fade)
            }, completion: nil)
        }
    }
}
