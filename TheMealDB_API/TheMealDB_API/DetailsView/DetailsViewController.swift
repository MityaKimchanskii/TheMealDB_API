//
//  DetailsViewController.swift
//  TheMealDB_API
//
//  Created by Mitya Kim on 4/7/23.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var meal: Meal?
    var ingredients: [String] = []
    var measures: [String] = []
    
    let mealImageView = UIImageView()
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    let nameLabel = UILabel()
    let instructionsLabel = UILabel()
    let instructionsDetailsLabel = UILabel()
    let componentsLabel = UILabel()
    let compositionStackView = UIStackView()
    let ingredientsStackView = UIStackView()
    let measuresStackView = UIStackView()
    let printButton = UIButton()
    
    let heightAndWidthImage: CGFloat = 200
    var imageViewTopConstraint: NSLayoutConstraint?
    
    struct printButtonSpacing {
        static let height: CGFloat = 60
        static let width: CGFloat = 60
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        printButtonAction()
        setupScrollView()
        style()
        fetchImage()
        fetchDetails()
        layout()
    }
}

// MARK: - Methods
extension DetailsViewController {
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
    
    private func setupScrollView() {
        scrollView.delegate = self
    }
    
    private func fetchDetails() {
        guard let mealID = meal?.mealID else { return }
        MealManager.fetchMealDetails(with: mealID) { [weak self] result in
            switch result {
            case .success(var details):
                self?.instructionsDetailsLabel.text = details.instructions
                
                let ingrArray = details.ingredients
                for i in ingrArray {
                    if i != "" && i != " " && i != nil {
                        self?.ingredients.append("👉\(i ?? "")")
                    }
                }
                
                let measArray = details.measures
                for i in measArray {
                    self?.measures.append("🥄\(i ?? "")")
                }
                self?.checkComponents()
                self?.components()
            case .failure(let error):
                print(error)
                print(error.localizedDescription)
            }
        }
    }
    
    private func checkComponents() {
        var newArray = [String]()
        for (i, _) in ingredients.enumerated() {
            newArray.append(measures[i])
        }
        measures = newArray
    }
    
    private func components() {
        var countIngr = 0
        for text in ingredients {
            ingredientsStackView.addArrangedSubview(makeLabel(name: text))
            countIngr += 1
        }
        
        var countMeas = 0
        for text in measures {
            measuresStackView.addArrangedSubview(makeLabel(name: text))
            countMeas += 1
        }
    }
    
    private func style() {
        view.backgroundColor = .white
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        mealImageView.translatesAutoresizingMaskIntoConstraints = false
        mealImageView.contentMode = .scaleAspectFit
        mealImageView.layer.cornerRadius = heightAndWidthImage/2
        mealImageView.clipsToBounds = true
        mealImageView.backgroundColor = .red
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.textAlignment = .center
        
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionsLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        instructionsLabel.text = "🔵 Instructions🧑‍🍳"
        
        instructionsDetailsLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionsDetailsLabel.font = UIFont.preferredFont(forTextStyle: .body)
        instructionsDetailsLabel.lineBreakMode = .byClipping
        instructionsDetailsLabel.numberOfLines = 0
        instructionsDetailsLabel.textAlignment = .justified
        
        componentsLabel.translatesAutoresizingMaskIntoConstraints = false
        componentsLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        componentsLabel.text = "🔵 Ingredients🥣"
        
        compositionStackView.translatesAutoresizingMaskIntoConstraints = false
        compositionStackView.axis = .horizontal
        compositionStackView.spacing = 8
        compositionStackView.alignment = .top
        compositionStackView.distribution = .fillEqually
        
        ingredientsStackView.translatesAutoresizingMaskIntoConstraints = false
        ingredientsStackView.axis = .vertical
        ingredientsStackView.spacing = 8
        
        measuresStackView.translatesAutoresizingMaskIntoConstraints = false
        measuresStackView.axis = .vertical
        measuresStackView.spacing = 8
        
        printButton.translatesAutoresizingMaskIntoConstraints = false
        printButton.setTitle("🖨️", for: .normal)
//        printButton.setImage(UIImage(systemName: "printer.fill"), for: .normal)
        printButton.titleLabel?.minimumScaleFactor = 0.5
        printButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        printButton.titleLabel?.adjustsFontSizeToFitWidth = true
        printButton.backgroundColor = .systemPink
        printButton.alpha = 0.9
        printButton.setTitleColor(.white, for: .normal)
        printButton.layer.cornerRadius = printButtonSpacing.height/2
    }
    
    private func layout() {
        view.addSubview(mealImageView)
        view.addSubview(scrollView)
        view.addSubview(printButton)
        scrollView.addSubview(stackView)
    
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(instructionsLabel)
        stackView.addArrangedSubview(instructionsDetailsLabel)
        stackView.addArrangedSubview(componentsLabel)
        stackView.addArrangedSubview(compositionStackView)
        
        compositionStackView.addArrangedSubview(ingredientsStackView)
        compositionStackView.addArrangedSubview(measuresStackView)
    
        imageViewTopConstraint = mealImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        
        NSLayoutConstraint.activate([
            imageViewTopConstraint!,
            mealImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mealImageView.heightAnchor.constraint(equalToConstant: heightAndWidthImage),
            mealImageView.widthAnchor.constraint(equalToConstant: heightAndWidthImage),
            
            scrollView.topAnchor.constraint(equalToSystemSpacingBelow: mealImageView.bottomAnchor, multiplier: 1),
            scrollView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: scrollView.trailingAnchor, multiplier: 2),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            printButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            printButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            printButton.widthAnchor.constraint(equalToConstant: printButtonSpacing.width),
            printButton.heightAnchor.constraint(equalToConstant: printButtonSpacing.height),
        ])
    }
    
    private func printButtonAction() {
        printButton.addTarget(self, action: #selector(printButtonTapped), for: .primaryActionTriggered)
    }
    
    @objc private func printButtonTapped(sender: UIButton) {
        let print = UIPrintInteractionController.shared
        let info = UIPrintInfo(dictionary: nil)
        info.outputType = .general
        info.jobName = "print..."
        print.printInfo = info
        print.printingItem = view.snapshot(scrollView: scrollView)
        print.present(animated: true)
    }
}

// MARK: - Animation
extension DetailsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        
        let swipingDown = y <= 0
        let shouldSnap = y > 150
        
        let labelHeight = mealImageView.frame.height
        
        UIView.animate(withDuration: 0.3) {
            self.mealImageView.alpha = swipingDown ? 1.0 : 0.0
        }
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0) {
            self.imageViewTopConstraint?.constant = shouldSnap ? -labelHeight : 0
            self.view.layoutIfNeeded()
        }
    }
}
