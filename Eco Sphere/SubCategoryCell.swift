import UIKit

class SubCategoryCell: UICollectionViewCell {
    
    // Программное создание элементов интерфейса
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(underlineView)
        
        // Констрейнты: жестко привязываем элементы к границам ячейки
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: underlineView.topAnchor, constant: -4),
            
            underlineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            underlineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            underlineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            underlineView.heightAnchor.constraint(equalToConstant: 3)
        ])
    }
    
    func configure(with title: String, isSelected: Bool) {
        titleLabel.text = title
        
        if isSelected {
            titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            titleLabel.textColor = .label
            underlineView.isHidden = false
            underlineView.alpha = 0
            UIView.animate(withDuration: 0.25) {
                self.underlineView.alpha = 1
            }
        } else {
            titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            titleLabel.textColor = .secondaryLabel
            underlineView.isHidden = true
        }
    }
}
#Preview {
    let cell = SubCategoryCell(frame: CGRect(x: 0, y: 0, width: 120, height: 44))
    cell.configure(with: "Макулатура", isSelected: true)
    return cell
}
