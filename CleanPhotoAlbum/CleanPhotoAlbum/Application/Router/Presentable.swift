//
//  Presentable.swift
//  CleanPhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 26/02/23.
//

import Foundation
import UIKit

protocol Presentable {
    
    func toPresent() -> UIViewController?
}

extension UIViewController : Presentable {
    func toPresent() -> UIViewController? {
        return self
    }
}
