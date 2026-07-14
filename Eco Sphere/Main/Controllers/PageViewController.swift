// логика свайпов

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var didMoveToPage: ((Int) -> Void)?
    private var currentIndex: Int = 0

    // ВАЖНО: Весь массив данных [WasteType] должен находиться строго ЗДЕСЬ, внутри класса
    let wasteDataList: [WasteType] = [
        WasteType(title: "Макулатура", imageName: "Wastepaper",
                  shortDescription: "• Картон, гофрокороб\n• Измельченная бумага из шредера\n• Втулки\n• Яичные кассеты\n• Книги, тетради, крафт, офисная бумага, газеты",
                  fullDescription: "Чтобы сдать макулатуру, необходимо отделить металлические элементы (пружины, скрепки) и пластиковые элементы (обложки, файлы, папки).\n\nПо возможности спрессуйте бумагу, чтобы уменьшить объем. Не сдавайте бумагу в пластиковых пакетах, достаточно перевязать кипу веревкой или сложить в коробку."),
        
        WasteType(title: "Стекло", imageName: "Glass",
                  shortDescription: "• Стеклянные бутылки\n• Банки от детского питания и консервации\n• Флаконы от духов и лекарств",
                  fullDescription: "Обязательно промойте тару от остатков содержимого. Снимите металлические крышки и plastic-дозаторы. Этикетки можно оставить."),
        
        WasteType(title: "Пластик", imageName: "Plastic",
                  shortDescription: "• ПЭТ-бутылки (маркировка 1)\n• Флаконы от бытовой химии (маркировка 2)\n• Контейнеры для еды (маркировка 5)",
                  fullDescription: "Обращайте внимание на треугольник маркировки на дне. Тщательно сполосните пластик и максимально сомните его перед сдачей."),
        
        WasteType(title: "Электро", imageName: "Electro",
                  shortDescription: "• Сломанные телефоны и зарядки\n• Бытовая техника\n• Провода, клавиатуры и мышки",
                  fullDescription: "Электронный лом содержит опасные вещества. Не выбрасывайте его в общий бак, сдавайте исключительно в специализированные пункты приема."),
        
        WasteType(title: "Органика", imageName: "Organic",
                  shortDescription: "• Очистки овощей и фруктов\n• Остатки готовой пищи\n• Чайные пакетики и кофейная гуща",
                  fullDescription: "Не смешивайте органику с пластиковой упаковкой. По возможности используйте домашние компостеры или специальные биоразлагаемые пакеты."),
        
        WasteType(title: "Металл", imageName: "Metall",
                  shortDescription: "• Алюминиевые банки от напитков\n• Жестяные банки от консервов\n• Металлические крышки",
                  fullDescription: "Сполосните банки от остатков еды. Жестяные банки рекомендуется аккуратно сплющить, чтобы они занимали меньше места при транспортировке.")
    ]

    lazy var orderedViewControllers: [UIViewController] = {
        var controllers = [UIViewController]()
        for data in wasteDataList {
            let vc = WasteDetailViewController()
            vc.wasteData = data
            controllers.append(vc)
        }
        return controllers
    }()

    // MARK: - стиль анимации на плавный скролл
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self

        if let firstVC = orderedViewControllers.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }

    func moveToPage(at index: Int) {
        guard index >= 0 && index < orderedViewControllers.count else { return }
        let direction: UIPageViewController.NavigationDirection = index > currentIndex ? .forward : .reverse
        currentIndex = index
        setViewControllers([orderedViewControllers[index]], direction: direction, animated: true, completion: nil)
    }

    // MARK: - UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = orderedViewControllers.firstIndex(of: viewController), index > 0 else { return nil }
        return orderedViewControllers[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = orderedViewControllers.firstIndex(of: viewController), index < orderedViewControllers.count - 1 else { return nil }
        return orderedViewControllers[index + 1]
    }

    // MARK: - UIPageViewControllerDelegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleVC = viewControllers?.first, let index = orderedViewControllers.firstIndex(of: visibleVC) {
            currentIndex = index
            didMoveToPage?(index)
        }
    }
}
