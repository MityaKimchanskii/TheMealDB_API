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
    
    static let reuseID = "mealCell"
    static let cellHeight: CGFloat = 116
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        mealImageView.translatesAutoresizingMaskIntoConstraints = false
        mealImageView.contentMode = .scaleAspectFit
        mealImageView.image = UIImage(systemName: "star.fill")
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func layout() {
        addSubview(mealImageView)
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            mealImageView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            mealImageView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            bottomAnchor.constraint(equalToSystemSpacingBelow: mealImageView.bottomAnchor, multiplier: 1),
            mealImageView.widthAnchor.constraint(equalToConstant: 100),
            
            nameLabel.centerYAnchor.constraint(equalTo: mealImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: mealImageView.trailingAnchor, multiplier: 2)
        ])
    }
}
