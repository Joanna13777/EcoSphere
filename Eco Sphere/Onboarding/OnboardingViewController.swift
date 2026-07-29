import UIKit

class OnboardingViewController: UIViewController {
    
    private var pageViewController: UIPageViewController!
    var pages: [OnboardingCardViewController] = []
    private var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupPages()
        setupPageViewController()
    }
    
    private func setupPages() {
        pages.removeAll() // Очищаем стек перед заполнением
        for data in onboardingData {
            let vc = OnboardingCardViewController(data: data)
            
            vc.onSkipPressed = { [weak self] in self?.finishOnboarding() }
            vc.onBackPressed = { [weak self] in self?.goToPreviousPage() }
            
            vc.onNextPressed = { [weak self] targetIndex in
                self?.goToPage(targetIndex)
            }
            
            vc.onLanguageChangedGlobal = { [weak self] in
                self?.pages.forEach { $0.refreshLanguage() }
            }
            
            pages.append(vc)
        }
    }
    
    private func setupPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        if let firstVC = pages.first {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
        }
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.frame = view.bounds
        pageViewController.didMove(toParent: self)
    }
    
    func goToPage(_ targetIndex: Int) {
        guard targetIndex >= 0 && targetIndex < pages.count else { return }
        let direction: UIPageViewController.NavigationDirection = targetIndex > currentIndex ? .forward : .reverse
        currentIndex = targetIndex
        pageViewController.setViewControllers([pages[targetIndex]], direction: direction, animated: false, completion: nil)
    }
    
    private func goToPreviousPage() {
        let previousIndex = currentIndex - 1
        if previousIndex >= 0 {
            goToPage(previousIndex)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    // на последнем экране теперь должно логически завершать онбординг и перенаправлять на экран «Виды» (то есть запускать ваш MainTabBarController)
    private func finishOnboarding() {
        UserDefaults.standard.set(false, forKey: "is_first_launch")
        // Перекидываем пользователя на главный экран приложения (MainTabBarController)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            let mainTabBar = MainTabBarController()
            window.rootViewController = mainTabBar
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? OnboardingCardViewController, let index = pages.firstIndex(of: vc), index > 0 else { return nil }
        return pages[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? OnboardingCardViewController, let index = pages.firstIndex(of: vc), index < pages.count - 1 else { return nil }
        return pages[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        // Если анимация свайпа успешно завершилась
               if completed,
                  let currentVC = pageViewController.viewControllers?.first as? OnboardingCardViewController,
                  let index = pages.firstIndex(of: currentVC) {
                   
                   // Просто обновляем текущий индекс контейнера.
                   // Каждая карточка сама знает свой индекс и уже отображает правильную точку при создании!
                   currentIndex = index
        }
    }
}
