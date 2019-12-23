//
//  BaiscNukeImage.swift
//  
//
//  Created by Stefano Bertagno on 17/12/2019.
//

import Nuke
import SwiftUI

/// A basic `NukeImageView`, with `Image` placeholder support.
public struct NukeImage: NukeImageView {
    /// The request image.
    @Binding var request: NukeRequestable
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
            ?? Image.clear)
        .equatable()
        .scale(scaling)
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
        PlaceholderNukeImage<V>($request).placeholder(placeholder)
    }
}
