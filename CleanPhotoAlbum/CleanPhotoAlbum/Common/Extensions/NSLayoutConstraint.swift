//
//  NSLayoutConstraint.swift
//  CleanPhotoAlbumTests
//
//  Created by Ramkumar Thiyyakat on 06/03/23.
//

import UIKit

extension NSLayoutConstraint
{
    func withPriority(_ priority: Float) -> NSLayoutConstraint
    {
        self.priority = UILayoutPriority(priority)
        return self
    }
}
