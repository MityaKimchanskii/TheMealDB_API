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

extension UIView {
    func snapshot(scrollView: UIScrollView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, true, UIScreen.main.scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let savedContentOffset = scrollView.contentOffset
        let savedFrame = frame
        scrollView.contentOffset = CGPoint.zero
        frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        scrollView.contentOffset = savedContentOffset
    
        frame = savedFrame
        UIGraphicsEndImageContext()
        
        return image
    }
}

class AnimationHelper {

    static var position = "position"

    static var screenBounds: CGRect {
        return UIScreen.main.bounds
    }
}
