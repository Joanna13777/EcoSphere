import UIKit

// MARK: - Верстка и Констрейнты
extension OnboardingCardViewController {
    
    func setupUI() {
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        backButton.isHidden = (data.pageIndex == 0)
        
        var languageConfig = UIButton.Configuration.plain()
        languageConfig.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        languageButton.configuration = languageConfig
        languageButton.tintColor = .black
        languageButton.layer.borderWidth = 0
        languageButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        languageButton.addTarget(self, action: #selector(languageAction), for: .touchUpInside)
        
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        registrationButton.addTarget(self, action: #selector(registrationTapped), for: .touchUpInside)
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        if let onboardingImage = UIImage(named: data.imageName) {
            imageView.image = onboardingImage
        }
        
        descriptionLabel.font = .systemFont(ofSize: 15, weight: .regular)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        
        skipButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        skipButton.addTarget(self, action: #selector(skipAction), for: .touchUpInside)
        
        pageControl.numberOfPages = onboardingData.count
        pageControl.currentPage = data.pageIndex
        pageControl.currentPageIndicatorTintColor = UIColor(red: 27/255, green: 94/255, blue: 32/255, alpha: 1)
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.addTarget(self, action: #selector(pageControlValueChanges(_:)), for: .valueChanged)
        
        let views = [backButton, languageButton, titleLabel, imageView, descriptionLabel, skipButton, pageControl, registrationButton]
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            // 1. Верхняя панель (Назад и Язык)
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            
            languageButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            languageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            languageButton.heightAnchor.constraint(equalToConstant: 32),
            
            // 2. Черный заголовок
            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            // 3. Картинка (Снова привязана к заголовку, так как кнопка ушла вниз)
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            
            
            // 4. Над кнопкой «Пропустить» расположился Текст описания
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: skipButton.topAnchor, constant: -16),
            
            // 3. Над кнопкой "Регистрация" расположена кнопка «Пропустить»
            skipButton.bottomAnchor.constraint(equalTo: registrationButton.topAnchor, constant: -12),
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skipButton.widthAnchor.constraint(equalToConstant: 200), // ЖЕСТКАЯ ШИРИНА: не даст кнопке схлопнуться горизонтально
            skipButton.heightAnchor.constraint(equalToConstant: 44),  // ЖЕСТКАЯ ВЫСОТА: гарантирует видимость кнопки
            
            // 2. Над ней (над точками пагинации) кнопка "Регистрация"
            registrationButton.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -16),
            registrationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registrationButton.heightAnchor.constraint(equalToConstant: 30),
            
            // 1. На самом дне Safe Area лежит Точки пагинации.
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20)

            
            
        ])
    }
}
