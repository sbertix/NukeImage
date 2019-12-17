//
//  Extensions.swift
//  
//
//  Created by Stefano Bertagno on 18/12/2019.
//

import SwiftUI

/// A completly clear `Image`.
public extension Image {
    /// An empty image.
    static var clear: Self {
        #if canImport(UIKit)
        return .init(uiImage: UIColor.clear.image())
        #elseif canImport(AppKit)
        return .init(nsImage: NSColor.clear.image())
        #else
        fatalError("You need to either import `UIKit` or `AppKit`.")
        #endif
    }
}

#if canImport(UIKit)
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
#endif

#if canImport(AppKit)
import AppKit

public extension NSColor {
    /// Return a `NSImage` of size `size`, filled with the instance's color.
    func image(size: CGSize = .init(width: 1, height: 1)) -> NSImage {
        NSImage(size: size, flipped: false) {
            self.drawSwatch(in: $0)
            return true
        }
    }
}
#endif
