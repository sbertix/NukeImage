//
//  NukeImage.swift
//  
//
//  Created by Stefano Bertagno on 18/12/2019.
//

import Nuke
import SwiftUI

/// A `protocol` describing `NukeImage` modifiers.
protocol NukeImageView: View {
    associatedtype Placeholder: View
    
    /// The placeholder.
    var placeholder: Placeholder? { get set }
    /// The rendering mode.
    var rendering: SwiftUI.Image.TemplateRenderingMode { get set }
    /// The resizing options.
    var resizing: Resizing { get set }
}
/// Modifiers extension.
extension NukeImageView {
    /// Adjust image `rendering` mode.
    func renderingMode(_ renderingMode: SwiftUI.Image.TemplateRenderingMode = .original) -> Self {
        var copy = self
        copy.rendering = renderingMode
        return copy
    }
    /// Resize image with given `capInsets` and `resizingMode`.
    func resizable(capInsets: EdgeInsets = EdgeInsets(),
                   resizingMode: SwiftUI.Image.ResizingMode = .stretch) -> Self {
        var copy = self
        copy.resizing = .capInsets(capInsets, resizingMode: resizingMode)
        return copy
    }
}
