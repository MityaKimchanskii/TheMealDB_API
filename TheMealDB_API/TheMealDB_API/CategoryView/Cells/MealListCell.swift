//
//  MealListCell.swift
//  TheMealDB_API
//
//  Created by Mitya Kim on 4/7/23.
//

import UIKit

class MealListCell: UITableViewCell {
    
    let mealImageView = UIImageView()
    let nameLabel = UILabel()
    let arrowImageView = UIImageView()
    
    static let reuseID = "mealCell"
    static let cellHeight: CGFloat = 116
    
    var meal: Meal? {
        didSet {
            updateView()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        selectionStyle = .none
    }
}

// MARK: - Methods
extension MealListCell {
    
    private func updateView() {
        guard let meal else { return }
        MealManager.fetchImage(meal: meal) { [weak self] result in
            switch result {
            case .success(let image):
                self?.nameLabel.text = meal.mealName
                self?.mealImageView.image = image
            case .failure(let error):
                print(error)
                print(error.localizedDescription)
            }
        }
    }
    
    private func setup() {
        mealImageView.translatesAutoresizingMaskIntoConstraints = false
        mealImageView.contentMode = .scaleAspectFit
        mealImageView.layer.cornerRadius = 50
        mealImageView.clipsToBounds = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.adjustsFontSizeToFitWidth = true
        
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.image = UIImage(systemName: "chevron.right")
        arrowImageView.clipsToBounds = true
        arrowImageView.tintColor = .systemPink
        arrowImageView.contentMode = .scaleAspectFit
    }
    
    private func layout() {
        addSubview(mealImageView)
        addSubview(nameLabel)
        addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            mealImageView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            mealImageView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            bottomAnchor.constraint(equalToSystemSpacingBelow: mealImageView.bottomAnchor, multiplier: 1),
            mealImageView.widthAnchor.constraint(equalToConstant: 100),
            
            nameLabel.centerYAnchor.constraint(equalTo: mealImageView.centerYAnchor),
            trailingAnchor.constraint(equalToSystemSpacingAfter: nameLabel.trailingAnchor, multiplier: 5),
            nameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: mealImageView.trailingAnchor, multiplier: 2),
            
            arrowImageView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            trailingAnchor.constraint(equalToSystemSpacingAfter: arrowImageView.trailingAnchor, multiplier: 0),
            arrowImageView.heightAnchor.constraint(equalToConstant: 30),
            arrowImageView.widthAnchor.constraint(equalToConstant: 20)
            
        ])
    }
}
