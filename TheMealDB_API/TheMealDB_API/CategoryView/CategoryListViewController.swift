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
    
    let arr = ["Swift", "JavaScript", "SwiftUI", "Python", "Objective-C", "HTML", "CSS"]
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCategories()
        style()
        layout()
    }
    
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
    }
    
    private func layout() {
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 0),
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: titleLabel.trailingAnchor, multiplier: 1),
            
            collectionView.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 2),
            collectionView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: collectionView.trailingAnchor, multiplier: 1),
            collectionView.heightAnchor.constraint(equalToConstant: 50),
            
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

