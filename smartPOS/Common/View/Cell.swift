import UIKit

enum CellStyle {
    case blue
    case gray
    
    func color() -> UIColor {
        switch self {
        case .blue:
            return UIColor.white.withAlphaComponent(1)
 
        case .gray:
            return UIColor.white.withAlphaComponent(0.7)
        }
    }
    
    func insets() -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
    }
}

class Cell: UICollectionViewCell {
    static let reuseIdentifier: String = "Cell"
    
    lazy var top: NSLayoutConstraint = self.background.topAnchor.constraint(equalTo: self.contentView.topAnchor)
    lazy var left: NSLayoutConstraint = self.background.leftAnchor.constraint(equalTo: self.contentView.leftAnchor)
    lazy var bottom: NSLayoutConstraint = self.background.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
    lazy var right: NSLayoutConstraint = self.background.rightAnchor.constraint(equalTo: self.contentView.rightAnchor)
    
    func setCell(style: CellStyle) {
//        background.backgroundColor = style.color()
        background.backgroundColor = .blue
        let insets = style.insets()
        
        top.constant = insets.top
        left.constant = insets.left
        bottom.constant = insets.bottom
        right.constant = insets.right
    }
    
    lazy var background: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        
        return view
    }()
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = nil
        contentView.addSubview(background)
        
        NSLayoutConstraint.activate([top, left, bottom, right])
    }
}
