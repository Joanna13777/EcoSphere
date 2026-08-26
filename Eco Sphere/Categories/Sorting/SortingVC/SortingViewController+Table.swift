import UIKit

// MARK: - UITableViewDataSource
extension SortingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleTableViewCell
        
        let article = articlesData[indexPath.row]
            cell.configure(with: article)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SortingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1. Создаем или достаем со Storyboard ваш экран деталей
        let detailVC = ArticleDetailViewController()
        
        // 2. БЕРЕМ выбранную статью из вашего массива мок-данных
        let selectedArticle = articlesData[indexPath.row]
        
        // 3. ОБЯЗАТЕЛЬНО передаем её в переменную экрана деталей (вот этот мостик!)
        detailVC.article = selectedArticle
        
        // 4. Открываем экран
        navigationController?.pushViewController(detailVC, animated: true)
    }

}
