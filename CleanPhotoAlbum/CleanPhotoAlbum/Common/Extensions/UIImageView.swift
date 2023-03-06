//
//  UIImageView.swift
//  PhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 15/12/22.
//

import UIKit

extension UIImageView {
    
    func dm_setImage(posterPath: String?, completion: (() -> Void)? = nil) {
        guard let posterPath = posterPath else { return }
        let imageURL = URL(string: posterPath)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: imageURL!)
            DispatchQueue.main.async {
                completion?()
                guard let data = data else { return }
                self.image = UIImage(data: data)
            }
        }
    }
}
