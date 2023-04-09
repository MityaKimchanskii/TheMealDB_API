//
//  CategoryListCell.swift
//  TheMealDB_API
//
//  Created by Mitya Kim on 4/8/23.
//
import UIKit

protocol CategoryDelegate: AnyObject {
    func didSelect(category: String)
}

class CategoryListCell: UICollectionViewCell {
    
    let nameLabel = UILabel()
   
    weak var delegate: CategoryDelegate?
    
    static let reuseID = "categoryCell"
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                contentView.backgroundColor = .systemPink
                guard let category = nameLabel.text else { return }
                delegate?.didSelect(category: category)
            } else {
                contentView.backgroundColor = .systemGray3
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        nameLabel.numberOfLines = 0
        nameLabel.textColor = .white
        nameLabel.adjustsFontSizeToFitWidth = true
        
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemGray3
    }
    
    private func layout() {
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
}
