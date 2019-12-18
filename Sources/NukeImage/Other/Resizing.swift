//
//  Resizing.swift
//  
//
//  Created by Stefano Bertagno on 17/12/2019.
//

import SwiftUI

/// Resizing reference.
enum Resizing {
    /// None.
    case none
    /// Cap insets and resizing mode.
    case capInsets(EdgeInsets, resizingMode: SwiftUI.Image.ResizingMode)
}

/// Extend `Image` to allow for resizing.
extension Image {
    /// Resize.
    func resizable(_ resizing: Resizing) -> Image {
        switch resizing {
        case .none: return self
        case .capInsets(let capInsets, let resizingMode):
            return self.resizable(capInsets: capInsets,
                                  resizingMode: resizingMode)
        }
    }
}
