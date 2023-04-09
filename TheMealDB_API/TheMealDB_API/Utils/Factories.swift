//
//  Factories.swift
//  TheMealDB_API
//
//  Created by Mitya Kim on 4/9/23.
//

import UIKit

func makeLabel(name: String) -> UILabel {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.preferredFont(forTextStyle: .body)
    label.textAlignment = .left
    label.text = name
    
    return label
}
