//
//  NukeImage.swift
//  NukeImage
//
//  Created by Stefano Bertagno on 20/08/2019.
//  Copyright © 2019 Stefano Bertagno. All rights reserved.
//

import Nuke
import SwiftUI

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
    @State private var image: Nuke.Image?
    /// The previous url.
    @State private var previousRequest: ImageRequest?
    
    /// The resource url.
    public var request: ImageRequest
    
    /// The placeholder. Defaullts to `nil`.
    fileprivate var placeholder: AnyView?
    /// Resizing settings.
    fileprivate var resizing: Resizing?
    /// Rendering mode.
    fileprivate var rendering: SwiftUI.Image.TemplateRenderingMode?

    // MARK: Lifecycle
    @available(*, deprecated, message: "switch to `BasicNukeImage` instead")
    /// Init with `NukeRequestable`.
    public init(_ requestable: NukeRequestable) {
        self.request = requestable.imageRequest
    }
    
    // MARK: View
    /// The actual view.
    public var body: some View {
        // load nuke.
        Nuke.ImagePipeline.shared.loadImage(with: request) {
            // adjuts previous url at the end.
            defer { self.previousRequest = self.request }
            switch $0 {
            case .success(let response): self.image = response.image
            case .failure: self.image = nil
            }
        }
        // return image.
        switch request.urlRequest.url == previousRequest?.urlRequest.url {
        case true:
            // check for a valid image.
            guard let view = self.image.map(SwiftUI.Image.init)?.renderingMode(rendering) else {
                return placeholder.flatMap(AnyView.init) ?? AnyView(EmptyView())
            }
            // compose.
            guard let resizing = resizing else { return AnyView(view) }
            return AnyView(view.resizable(capInsets: resizing.capInsets,
                                          resizingMode: resizing.resizingMode))
        case false:
            return placeholder.flatMap(AnyView.init) ?? AnyView(EmptyView())
        }
    }
    
    // MARK: Deprecated
    @available(*, deprecated, message: "use `.init(_:).placeholder(_:)` instead.")
    /// Init with an `ImageRequest`.
    public init<P>(_ request: ImageRequest, placeholder: P?) where P: View {
        self.request = request
        self.placeholder = placeholder.flatMap(AnyView.init)
    }
    @available(*, deprecated, message: "use `.init(_:).placeholder(_:)` instead.")
    /// Init with a content `url`, and a `placeholder` `Image`.
    public init<P>(url: URL, placeholder: P? = nil) where P: View {
        self.request = ImageRequest(url: url)
        self.placeholder = placeholder.flatMap(AnyView.init)
    }
}

// MARK: Image pseudo-conformacy
public extension NukeImage {
    /// Update placeholder.
    func placeholder<V>(_ placeholder: V) -> NukeImage where V: View {
        var copy = self
        copy.placeholder = AnyView(placeholder)
        return copy
    }
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
