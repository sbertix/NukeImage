//
//  Resizing.swift
//  
//
//  Created by Stefano Bertagno on 17/12/2019.
//

import SwiftUI

/// Resizing reference.
public enum Resizing {
    /// None.
    case none
    /// Cap insets and resizing mode.
    case capInsets(EdgeInsets, resizingMode: SwiftUI.Image.ResizingMode)
}
/// Extend `Image` to allow for resizing.
public extension Image {
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

/// Scaling reference.
public enum Scaling {
    /// None.
    case none
    /// Fill.
    case fill
    /// Fit.
    case fit
}
/// Extend `View` to allow for scaling.
public extension View {
    /// Scale.
    func scale(_ scaling: Scaling) -> some View {
        GeometryReader {
            Group {
                if scaling == .none {
                    self
                } else if scaling == .fill {
                    self.scaledToFill()
                } else if scaling == .fit {
                    self.scaledToFit()
                }
            }.frame(width: $0.size.width, height: $0.size.height)
        }
    }
}
