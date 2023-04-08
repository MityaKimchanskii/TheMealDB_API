//
//  MealListViewController.swift
//  TheMealDB_API
//
//  Created by Mitya Kim on 4/7/23.
//

import UIKit

class MealListViewController: UIViewController {
    
    let tableView = UITableView()
    
    let arr = ["Swift", "JavaScript", "SwiftUI", "Python", "Objective-C", "HTML", "CSS"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
    
    private func style() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MealListCell.self, forCellReuseIdentifier: MealListCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func layout() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UITabelViewDelegate, UITableViewDataSource
extension MealListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MealListCell.reuseID, for: indexPath) as! MealListCell
        let text = arr[indexPath.row]
        cell.nameLabel.text = text
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MealListCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let text = arr[indexPath.row]
        let detailsVC = DetailsViewController()
        detailsVC.nameLabel.text = text
        
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}


