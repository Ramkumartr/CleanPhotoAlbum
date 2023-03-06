//
//  UIBarButtonItem.swift
//  PhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 17/12/22.
//

import UIKit

extension UIBarButtonItem {
    static func backButton(target: Any?, action: Selector?) -> UIBarButtonItem {
        let backButton = UIBarButtonItem(image: UIImage(named: "ArrowLeft"), style: .plain, target: target, action: action)
        backButton.tintColor = UIColor.Brand.popsicle40
        return backButton
    }
    
    static func favouriteButton(target: Any?, action: Selector?, isSelected: Bool) -> UIBarButtonItem {
        
        let favButton = UIBarButtonItem(image: isSelected ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), style: .plain, target: target, action: action)
        
        favButton.tintColor  = UIColor.Brand.popsicle40
        return favButton
    }
    
    
}
