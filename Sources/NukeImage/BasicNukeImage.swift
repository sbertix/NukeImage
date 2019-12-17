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
    /// The request image.
    @Binding var request: NukeRequestable
    /// The image.
    @State private var image: Nuke.Image? = nil
    
    /// The placeholder.
    private var placeholder: SwiftUI.Image? = nil
    /// The rendering mode.
    private var rendering: SwiftUI.Image.TemplateRenderingMode = .original
    /// The resizing options.
    private var resizing: Resizing = .none
    
    // MARK: Init
    /// Init with request.
    public init(_ request: Binding<NukeRequestable>) {
        self._request = request
    }
    /// Init with request.
    public init<Request>(_ request: Request) where Request: NukeRequestable {
        self._request = .constant(request.imageRequest)
    }
        
    // MARK: Lifecycle
    /// The actual image.
    public var imageBody: some View {
        (self.image.flatMap(SwiftUI.Image.init)?
                .renderingMode(rendering)
                .resizable(resizing)
            ?? placeholder
            ?? Image(.init()))
        .equatable()
    }
    /// The actual body.
    public var body: some View {
        imageBody.onAppear { [imageRequest = request.imageRequest] in
            // load pipeline.
            self.image = nil
            Nuke.ImagePipeline.shared.loadImage(with: imageRequest) {
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
        copy.resizing = .capInsets(capInsets, resizingMode: resizingMode)
        return copy
    }
}
