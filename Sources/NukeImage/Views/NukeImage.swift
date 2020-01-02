//
//  BaiscNukeImage.swift
//  
//
//  Created by Stefano Bertagno on 17/12/2019.
//

import Nuke
import SwiftUI

/// A basic `NukeImageView`, with `Image` placeholder support.
public struct NukeImage<Request: NukeRequestable>: NukeImageView {
    /// The request image.
    @Binding var request: Request
    /// The previous request.
    @State private var previousRequest: Request?
    /// The image.
    @State private var image: Nuke.Image? = nil
    
    /// The placeholder.
    public var placeholder: SwiftUI.Image? = nil
    /// The rendering mode.
    public var rendering: SwiftUI.Image.TemplateRenderingMode = .original
    /// The resizing options.
    public var resizing: Resizing = .none
    /// The scaling options.
    public var scaling: Scaling = .none
    
    // MARK: Init
    /// Init with request.
    public init(_ request: Binding<Request>) {
        self._request = request
    }
    /// Init with request.
    public init(_ request: Request) {
        self._request = .constant(request)
    }
        
    // MARK: Lifecycle
    /// The actual image.
    public var imageBody: some View {
        (self.image.flatMap(SwiftUI.Image.init)?
                .renderingMode(rendering)
                .resizable(resizing)
            ?? placeholder
            ?? Image.clear)
        .equatable()
        .scale(scaling)
    }
    /// The actual body.
    public var body: some View {
        // fetch new image when necessary.
        if previousRequest?.imageRequest.urlRequest.url != request.imageRequest.urlRequest.url { fetch() }
        return imageBody
    }
    
    // MARK: Fetch
    func fetch() {
        // load pipeline.
        self.previousRequest = request
        self.image = nil
        Nuke.ImagePipeline.shared.loadImage(with: request.imageRequest) {
            self.image = try? $0.get().image
        }
    }
}

/// Modifiers extension.
public extension NukeImage {
    /// Set `placeholder`.
    func placeholder(_ placeholder: SwiftUI.Image?) -> some NukeImageView  {
        var copy = self
        copy.placeholder = placeholder
        return copy
    }
    /// Set `placeholder`.
    func placeholder(_ placeholderImage: Nuke.Image?) -> some NukeImageView {
        var copy = self
        copy.placeholder = placeholderImage.flatMap(SwiftUI.Image.init)
        return copy
    }
    /// Set `placeholder`.
    func placeholder<V>(_ placeholder: V) -> some NukeImageView where V: View {
        PlaceholderNukeImage<V, Request>($request).placeholder(placeholder)
    }
}
