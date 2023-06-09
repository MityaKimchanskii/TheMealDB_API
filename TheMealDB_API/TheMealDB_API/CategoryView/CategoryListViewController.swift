//
//  CategoryListViewController.swift
//  TheMealDB_API
//
//  Created by Mitya Kim on 4/8/23.
//

import UIKit


class CategoryListViewController: UIViewController {
    
    private var categories: [Category] = []
    private var meals: [Meal] = []
    
    let titleLabel = UILabel()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CategoryListCell.self, forCellWithReuseIdentifier: CategoryListCell.reuseID)
        cv.allowsSelection = true
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        cv.dataSource = self
        cv.delegate = self
        
        return cv
    }()
    
    let tableView = UITableView()
    
    let animationImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Methods
extension CategoryListViewController {
    
    private func style() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.text = "Hey Chef, what are we cooking today?🧑‍🍳"
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MealListCell.self, forCellReuseIdentifier: MealListCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
        
        animationImageView.translatesAutoresizingMaskIntoConstraints = false
        animationImageView.image = UIImage(systemName: "fork.knife.circle.fill")
        animationImageView.tintColor = .systemPink
        animationImageView.contentMode = .scaleAspectFit
        animationImageView.alpha = 0.8
    }
    
    private func layout() {
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(tableView)
        view.addSubview(animationImageView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 0),
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: titleLabel.trailingAnchor, multiplier: 1),
            
            collectionView.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 2),
            collectionView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: collectionView.trailingAnchor, multiplier: 1),
            collectionView.heightAnchor.constraint(equalToConstant: 50),
            
            view.leadingAnchor.constraint(equalToSystemSpacingAfter: animationImageView.leadingAnchor, multiplier: 8),
            animationImageView.heightAnchor.constraint(equalToConstant: 50),
            animationImageView.widthAnchor.constraint(equalToConstant: 50),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: animationImageView.bottomAnchor, multiplier: 0),
            
            tableView.topAnchor.constraint(equalToSystemSpacingBelow: collectionView.bottomAnchor, multiplier: 2),
            tableView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: tableView.trailingAnchor, multiplier: 2),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func fetchCategories() {
        MealManager.fetchCategories { [weak self] result in
            switch result {
            case .success(let categories):
                self?.categories = categories
                self?.collectionView.reloadData()
            case .failure(let error):
                print(error)
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchMeals(category: String) {
        MealManager.fetchMeals(category: category) { [weak self] result in
            switch result {
            case .success(let meals):
                self?.meals = meals
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
                print(error.localizedDescription)
            }
        }
    }
    
    private func setup() {
        fetchCategories()
        style()
        layout()
        activateAnimation()
    }
}

// MARK: - Category delegate
extension CategoryListViewController: CategoryDelegate {
    func didSelect(category: String) {
        fetchMeals(category: category)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CategoryListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryListCell.reuseID, for: indexPath) as! CategoryListCell
        let category = categories[indexPath.row]
        cell.nameLabel.text = category.categoryName
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}

// MARK: - UITabelViewDelegate, UITableViewDataSource
extension CategoryListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MealListCell.reuseID, for: indexPath) as! MealListCell
        let meal = meals[indexPath.row]
        cell.meal = meal
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MealListCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meal = meals[indexPath.row]
        let detailsVC = DetailsViewController()
        detailsVC.meal = meal
        
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}

// MARK: - Animation
extension CategoryListViewController {
   
    private func boundsKeyFrameAnimation() -> CAKeyframeAnimation {
        let bounce = CAKeyframeAnimation(keyPath: AnimationHelper.position)
        bounce.duration = 3.5
        bounce.repeatCount = 1
        bounce.values = [
            NSValue(cgPoint: CGPoint(x: 25, y: AnimationHelper.screenBounds.height - 100)),
            NSValue(cgPoint: CGPoint(x: 75, y: AnimationHelper.screenBounds.height - 150)),
            NSValue(cgPoint: CGPoint(x: 125, y: AnimationHelper.screenBounds.height - 100)),
            NSValue(cgPoint: CGPoint(x: 225, y: AnimationHelper.screenBounds.height - 150)),
            NSValue(cgPoint: CGPoint(x: 325, y: AnimationHelper.screenBounds.height - 100)),
            NSValue(cgPoint: CGPoint(x: AnimationHelper.screenBounds.width + 200, y: AnimationHelper.screenBounds.height - 250))
        ]
        
        bounce.keyTimes =  [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]
        
        return bounce
    }
    
    private func activateAnimation() {
        animationImageView.layer.add(boundsKeyFrameAnimation(), forKey: "bounce")
    }
}

