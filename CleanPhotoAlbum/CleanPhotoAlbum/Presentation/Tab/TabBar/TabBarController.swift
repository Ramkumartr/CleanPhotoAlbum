//
//  TabBarController.swift
//  PhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 01/03/23.
//

import UIKit

class TabBarController: UITabBarController {
    
    
    // MARK: - Lifecycle
    static func create() -> TabBarController {
        TabBarController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tabBar.tintColor = .label
       // self.hidesBottomBarWhenPushed = true
       // setupVCs()
    }
    
  
}
