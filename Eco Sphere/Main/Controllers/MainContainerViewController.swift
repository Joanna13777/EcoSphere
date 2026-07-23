// главный экран с коллекцией в стиле Eco-Minimalism

import UIKit

class MainContainerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private var collectionView: UICollectionView!
    private let pageViewController = PageViewController()
    
    private var titles: [String] = []
    private var selectedIndex: Int = 0
    
    // массив системных иконок, строго совпадающий по порядку с категориями
    private let tabIcons = [
        "shippingbox.fill",              // Макулатура
        "wineglass.fill",                // Стекло
        "takeoutbag.and.cup.and.straw.fill",              // Пластик
        "cylinder.split.1x2.fill",       // Металл wrench.and.screwdriver.fill
        "leaf.fill",                     // Органика
        "iphone.gen1"                    // Электро (или "iphone")
        
    ]
    
    // Палитра для главного контейнера
    private let appBgColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0) // #F5F5F5 (Мягкий серый)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = appBgColor // Меняем стандартный фон на пастельный эко-оттенок
        
        title = "Виды"

        setupMainConfiguration()
        setupCollectionView()
        setupPageViewController()
        setupLayout()
    }
    
    // MARK: - Первичная настройка
    private func setupMainConfiguration() {
        view.backgroundColor = appBgColor
        
        // Создаем кастомную кнопку со стрелкой
            let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(backTapped))
            
            // Красим стрелочку в черный (под ваш стиль)
            backButton.tintColor = .black
            
            // Устанавливаем кнопку слева на верхнем баре
            navigationItem.leftBarButtonItem = backButton
        }

        // Метод, который будет срабатывать при нажатии
        @objc private func backTapped() {
            // Если это Push-переход:
            navigationController?.popViewController(animated: true)
            
            // Или если это Modal-переход:
             dismiss(animated: true, completion: nil)
        
        
        // Прячет текст кнопки назад для всех экранов, открываемых из этого контроллера
            let backButton = UIBarButtonItem()
            backButton.title = ""
            navigationItem.backBarButtonItem = backButton
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = .zero // Включаем авто-размер ячеек под длину текста
        layout.minimumInteritemSpacing = 8
        
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
        
        // Фон самого контейнера страниц тоже делаем прозрачным, чтобы видеть эко-подложку
        pageViewController.view.backgroundColor = .clear
        
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
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
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
    
    //  метод cellForItemAt, чтобы он передавал иконку в ячейку
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryCell", for: indexPath) as! SubCategoryCell
        
        guard indexPath.item < titles.count else { return cell }
        
        let isCurrentSelected = (indexPath.item == selectedIndex)
        let title = titles[indexPath.item]
        
        // ЗАЩИТА: Берем иконку из массива, если индекс корректен, иначе ставим дефолтную звезду
        let iconName = indexPath.item < tabIcons.count ? tabIcons[indexPath.item] : "star.fill"
        
        cell.configure(with: title, iconName: iconName, isSelected: isCurrentSelected)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Если нажали на уже активную вкладку — ничего не делаем
        guard indexPath.item != selectedIndex else { return }
        
        // 1. Меняем индекс на выбранный
        selectedIndex = indexPath.item
        
        // 2. Листаем контейнер страниц программно (сработает анимация scroll)
        pageViewController.moveToPage(at: indexPath.item)
        
        // 3. Доворачиваем саму нажатую кнопку по центру экрана
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        // 4. Перерисовываем ячейки, чтобы обновить их визуальное состояние (активная/неактивная)
        collectionView.reloadData()
    }

    
    // расчет размера sizeForItemAt (добавляем ширину иконки в формулу)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard indexPath.item < titles.count else { return CGSize(width: 120, height: 40) }
        
        let text: String = titles[indexPath.item]
        let font: UIFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        let attributes: [NSAttributedString.Key : Any] = [.font : font]
        let textWidth: CGFloat = text.size(withAttributes: attributes).width
        
        // ФОРМУЛА: Ширина текста + Ширина иконки (18) + Расстояние между ними (8) + Боковые поля (36)
        let totalWidth = textWidth + 18 + 8 + 36
        
        return CGSize(width: totalWidth, height: 40)
    }
    
    // MARK: - Логика доводки (Snap to Center) при скролле верхнего меню руками
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            snapTabBarToNearestCell()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerating: Bool) {
        if scrollView == collectionView && !decelerating {
            snapTabBarToNearestCell()
        }
    }
    
    private func snapTabBarToNearestCell() {
        // Вычисляем точку центра видимой области коллекции кнопок
        let centerPoint = CGPoint(x: collectionView.center.x + collectionView.contentOffset.x, y: collectionView.center.y)
        
        // Находим ячейку, которая оказалась ближе всего к центру экрана
        if let indexPath = collectionView.indexPathForItem(at: centerPoint) {
            
            // ЗАЩИТА: Проверяем, что индекс физически существует в массиве данных
            guard indexPath.item >= 0 && indexPath.item < titles.count else { return }
            
            selectedIndex = indexPath.item
            
            // 1. Доскролливаем кнопку ровно по центру горизонтали
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            // 2. Даем команду нижнему контейнеру страниц переключить экран
            pageViewController.moveToPage(at: indexPath.item)
            
            // 3. Обновляем цвета кнопок
            collectionView.reloadData()
        }
    }
}

//#Preview {
//    let mainContainerVC = MainContainerViewController()
//    return UINavigationController(rootViewController: mainContainerVC)
//}
