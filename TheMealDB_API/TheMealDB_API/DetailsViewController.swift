//
//  DetailsViewController.swift
//  TheMealDB_API
//
//  Created by Mitya Kim on 4/7/23.
//

import UIKit

class DetailsViewController: UIViewController {
    
    let mealImageView = UIImageView()
    let nameLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        layout()
    }
    
    private func style() {
        view.backgroundColor = .white
        
        mealImageView.translatesAutoresizingMaskIntoConstraints = false
        mealImageView.image = UIImage(systemName: "star.fill")
        mealImageView.contentMode = .scaleAspectFit
        mealImageView.tintColor = .systemPink
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
    }
    
    private func layout() {
        view.addSubview(mealImageView)
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            mealImageView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            mealImageView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: mealImageView.trailingAnchor, multiplier: 2),
            mealImageView.heightAnchor.constraint(equalToConstant: 200),
//            mealImageView.widthAnchor.constraint(equalToConstant: 200),
            
            nameLabel.topAnchor.constraint(equalToSystemSpacingBelow: mealImageView.bottomAnchor, multiplier: 2),
            nameLabel.centerXAnchor.constraint(equalTo: mealImageView.centerXAnchor)
            
        ])
    }
}
