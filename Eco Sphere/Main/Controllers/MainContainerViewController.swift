// главный экран с коллекцией

import UIKit

class MainContainerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    private var collectionView: UICollectionView!
    private let pageViewController = PageViewController()
    
    private var titles: [String] = []
    private var selectedIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Виды"
        
        setupCollectionView()
        setupPageViewController()
        setupLayout()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        collectionView.register(SubCategoryCell.self, forCellWithReuseIdentifier: "SubCategoryCell")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
    }
    
    private func setupPageViewController() {
        // Программный аналог связи Embed Segue
        addChild(pageViewController)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        self.titles = pageViewController.wasteDataList.map { $0.title }
        
        pageViewController.didMoveToPage = { [weak self] index in
            guard let self = self else { return }
            self.selectedIndex = index
            self.collectionView.reloadData()
            let indexPath = IndexPath(item: index, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            // Верхнее горизонтальное меню под навигатором
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 44),
            
            // Нижняя лента свайп-страниц, забирающая всё пространство до низа
            pageViewController.view.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - UICollectionView Data Source & Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryCell", for: indexPath) as! SubCategoryCell
        let isCurrentSelected = (indexPath.item == selectedIndex)
        cell.configure(with: titles[indexPath.item], isSelected: isCurrentSelected)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        collectionView.reloadData()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageViewController.moveToPage(at: indexPath.item)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text: String = titles[indexPath.item]
        let font: UIFont = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        // Оптимизировано: строгий тип словаря защищает Xcode от зависаний при компиляции
        let attributes: [NSAttributedString.Key : Any] = [.font : font]
        let textWidth: CGFloat = text.size(withAttributes: attributes).width
        
        return CGSize(width: textWidth + 28, height: 44)
    }
}

#Preview {
    let mainContainerVC = MainContainerViewController()
    
    // Отображаем экран внутри навигационного контроллера
    return UINavigationController(rootViewController: mainContainerVC)
}
