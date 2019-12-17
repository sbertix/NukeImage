//
//  BaiscNukeImage.swift
//  
//
//  Created by Stefano Bertagno on 17/12/2019.
//

import Nuke
import SwiftUI

/// A basic `NukeImageView`, with no placeholder support.
public struct BasicNukeImage: View {
    /// Resizing reference.
    fileprivate struct Resizing {
        /// Cap insets.
        let capInsets: EdgeInsets
        /// Resizing mode.
        let resizingMode: SwiftUI.Image.ResizingMode
    }

    /// The request image.
    @Binding var request: ImageRequest
    /// The image.
    @State private var image: Nuke.Image? = nil
    
    /// The placeholder.
    private var placeholder: SwiftUI.Image? = nil
    /// The rendering mode.
    private var rendering: SwiftUI.Image.TemplateRenderingMode = .original
    /// The resizing options.
    private var resizing: Resizing? = nil
    
    // MARK: Init
    /// Init with request.
    public init(_ request: Binding<ImageRequest>) {
        self._request = request
    }
    /// Init with request.
    public init(_ request: ImageRequest) {
        self._request = .constant(request)
    }
        
    // MARK: Lifecycle
    /// The actual image.
    public var imageBody: some View {
        let image = self.image.flatMap(SwiftUI.Image.init)
            ?? placeholder
            ?? Image(.init())
        // resize and render.
        return (resizing.flatMap { image.resizable(capInsets: $0.capInsets, resizingMode: $0.resizingMode) } ?? image)
            .renderingMode(rendering)
            .equatable()
    }
    /// The actual body.
    public var body: some View {
        imageBody.onAppear { [request] in
            // load pipeline.
            Nuke.ImagePipeline.shared.loadImage(with: request) {
                self.image = try? $0.get().image
            }
        }
    }
}
/// Modifiers extension.
public extension BasicNukeImage {
    /// Set `placeholder`.
    func placeholder(_ placeholder: SwiftUI.Image?) -> Self  {
        var copy = self
        copy.placeholder = placeholder
        return copy
    }
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
        copy.resizing = .init(capInsets: capInsets, resizingMode: resizingMode)
        return copy
    }
}
