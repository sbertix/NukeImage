//
//  NukeImage.swift
//  NukeImage
//
//  Created by Stefano Bertagno on 20/08/2019.
//  Copyright © 2019 Stefano Bertagno. All rights reserved.
//

import Nuke
import SwiftUI
import UIKit

/// A `View` loading images asynchronously from a given `URL` using `Nuke`.
public struct NukeImage: View {
    /// Resizing reference.
    fileprivate struct Resizing {
        /// Cap insets.
        let capInsets: EdgeInsets
        /// Resizing mode.
        let resizingMode: SwiftUI.Image.ResizingMode
    }
    
    /// The image.
    @State private var image: UIImage? = nil
    /// The previous url.
    @State private var previousUrl: URL? = nil
    /// Resizing settings.
    fileprivate var resizing: Resizing?
    /// Rendering mode.
    fileprivate var rendering: SwiftUI.Image.TemplateRenderingMode?
    
    /// The placeholder. Defaullts to `UIColor.systemGroupedBackground.image()`.
    public var placeholder: SwiftUI.Image
    /// The resource url.
    public var url: URL
    
    /// Init with a content `url`, and a `placeholder` `Image`.
    public init(url: URL, placeholder: SwiftUI.Image = Image(uiImage: UIColor.systemGroupedBackground.image())) {
        self.url = url
        self.placeholder = placeholder
    }
    
    /// The actual view.
    public var body: some View {
        // load nuke.
        Nuke.ImagePipeline.shared.loadImage(with: url) {
            // adjuts previous url at the end.
            defer { self.previousUrl = self.url }
            switch $0 {
            case .success(let response): self.image = response.image
            case .failure: self.image = nil
            }
        }
        // return image.
        let body: SwiftUI.Image = (previousUrl != url
            ? placeholder
            : image.flatMap(SwiftUI.Image.init) ?? placeholder)
            .renderingMode(rendering)
        // resize.
        guard let resizing = resizing else { return body }
        return body.resizable(capInsets: resizing.capInsets,
                              resizingMode: resizing.resizingMode)
    }
}

// MARK: Image pseudo-conformacy
public extension NukeImage {
    /// Resize image with given `capInsets` and `resizingMode`.
    func resizable(capInsets: EdgeInsets = EdgeInsets(),
                   resizingMode: SwiftUI.Image.ResizingMode = .stretch) -> NukeImage {
        var copy = self
        copy.resizing = .init(capInsets: capInsets, resizingMode: resizingMode)
        return copy
    }
    /// Adjust image rendering mode.
    func renderingMode(_ renderingMode: SwiftUI.Image.TemplateRenderingMode?) -> NukeImage {
        var copy = self
        copy.rendering = renderingMode
        return copy
    }
}
