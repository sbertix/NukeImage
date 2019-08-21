//
//  UIColor+UIImage.swift
//  NukeImage
//
//  Created by Stefano Bertagno on 20/08/2019.
//  Copyright © 2019 Stefano Bertagno. All rights reserved.
//

import UIKit

public extension UIColor {
    /// Return a `UIImage` of size `size`, filled with the instance's color.
    func image(size: CGSize = .init(width: 1, height: 1)) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
