//
//  DetailsViewController.swift
//  TheMealDB_API
//
//  Created by Mitya Kim on 4/7/23.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var meal: Meal? {
        didSet {
            updateView()
        }
    }
    
    let mealImageView = UIImageView()
    let stackView = UIStackView()
    let nameLabel = UILabel()
    let instructionsLabel = UILabel()
   
    
    let heightAndWidthImage: CGFloat = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        fetchImage()
        fetchDetails()
        layout()
    }
    
    private func updateView() {
        
        nameLabel.text = meal?.mealName
    }
    
    private func fetchImage() {
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
    
    private func fetchDetails() {
        guard let mealID = meal?.mealID else { return }
        MealManager.fetchMealDetails(with: mealID) { [weak self] result in
            switch result {
            case .success(let details):
                self?.instructionsLabel.text = details.instructions
            case .failure(let error):
                print(error)
                print(error.localizedDescription)
            }
        }
    }
    
    private func style() {
        view.backgroundColor = .white
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
//        stackView.distribution = .fill
        stackView.alignment = .center
        
        mealImageView.translatesAutoresizingMaskIntoConstraints = false
        mealImageView.contentMode = .scaleAspectFit
        mealImageView.layer.cornerRadius = heightAndWidthImage/2
        mealImageView.clipsToBounds = true
        mealImageView.backgroundColor = .red
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.textAlignment = .center
        
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionsLabel.font = UIFont.preferredFont(forTextStyle: .body)
        instructionsLabel.lineBreakMode = .byClipping
        instructionsLabel.numberOfLines = 0
        instructionsLabel.textAlignment = .justified
    }
    
    private func layout() {
        view.addSubview(mealImageView)
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(instructionsLabel)
        
        NSLayoutConstraint.activate([
            mealImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mealImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mealImageView.heightAnchor.constraint(equalToConstant: heightAndWidthImage),
            mealImageView.widthAnchor.constraint(equalToConstant: heightAndWidthImage),
            
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: mealImageView.bottomAnchor, multiplier: 1),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2),
            
        ])
    }
}
