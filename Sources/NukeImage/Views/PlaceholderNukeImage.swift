//
//  PlaceholderNukeImage.swift
//  
//
//  Created by Stefano Bertagno on 18/12/2019.
//

import Nuke
import SwiftUI

/// A basic `NukeImageView`, with any placeholder support.
public struct PlaceholderNukeImage<Placeholder: View>: NukeImageView {
    /// The request image.
    @Binding var request: NukeRequestable
    /// The image.
    @State private var image: Nuke.Image? = nil
    
    /// The placeholder.
    public var placeholder: Placeholder? = nil
    /// The rendering mode.
    public var rendering: SwiftUI.Image.TemplateRenderingMode = .original
    /// The resizing options.
    public var resizing: Resizing = .none
    
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
        image.flatMap(SwiftUI.Image.init)?
            .renderingMode(rendering)
            .resizable(resizing)
            .equatable()
    }
    /// The actual body.
    public var body: some View {
        Group {
            if image == nil {
                self.placeholder
            } else {
                self.imageBody
            }
        }.onAppear { [imageRequest = request.imageRequest] in
            // load pipeline.
            self.image = nil
            Nuke.ImagePipeline.shared.loadImage(with: imageRequest) {
                self.image = try? $0.get().image
            }
        }
    }
}

/// Modifiers extension.
public extension PlaceholderNukeImage {
    /// Set `placeholder`.
    func placeholder(_ placeholder: SwiftUI.Image?) -> NukeImage  {
        NukeImage($request).placeholder(placeholder)
    }
    /// Set `placeholder`.
    func placeholder(_ placeholderImage: Nuke.Image?) -> NukeImage {
        NukeImage($request).placeholder(placeholderImage)
    }
    /// Set `placeholder`.
    func placeholder(_ placeholder: Placeholder?) -> Self {
        var copy = self
        copy.placeholder = placeholder
        return copy
    }
}
