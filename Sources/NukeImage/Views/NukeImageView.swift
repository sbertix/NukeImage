//
//  NukeImage.swift
//  
//
//  Created by Stefano Bertagno on 18/12/2019.
//

import Nuke
import SwiftUI

/// A `protocol` describing `NukeImage` modifiers.
public protocol NukeImageView: View {
    associatedtype Placeholder: View
    
    /// The placeholder.
    var placeholder: Placeholder? { get set }
    /// The rendering mode.
    var rendering: SwiftUI.Image.TemplateRenderingMode { get set }
    /// The resizing options.
    var resizing: Resizing { get set }
    /// The scaling options.
    var scaling: Scaling { get set }
}
/// Modifiers extension.
public extension NukeImageView {
    /// Adjust image `rendering` mode.
    func renderingMode(_ renderingMode: SwiftUI.Image.TemplateRenderingMode = .original) -> some NukeImageView {
        var copy = self
        copy.rendering = renderingMode
        return copy
    }
    /// Resize image with given `capInsets` and `resizingMode`.
    func resizable(capInsets: EdgeInsets = EdgeInsets(),
                   resizingMode: SwiftUI.Image.ResizingMode = .stretch) -> some NukeImageView {
        var copy = self
        copy.resizing = .capInsets(capInsets, resizingMode: resizingMode)
        return copy
    }
    /// Scale image.
    func fetchedImageScale(_ scaling: Scaling) -> some NukeImageView {
        var copy = self
        copy.scaling = scaling
        return copy
    }
}
