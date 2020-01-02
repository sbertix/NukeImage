//
//  PlaceholderNukeImage.swift
//  
//
//  Created by Stefano Bertagno on 18/12/2019.
//

import Nuke
import SwiftUI

/// A basic `NukeImageView`, with any placeholder support.
public struct PlaceholderNukeImage<Placeholder: View, Request: NukeRequestable>: NukeImageView {
    /// The request image.
    @Binding var request: Request
    /// The previous request.
    @State private var previousRequest: Request?
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
        image.flatMap(SwiftUI.Image.init)?
            .renderingMode(rendering)
            .resizable(resizing)
    }
    /// The actual body.
    public var body: some View {
        // fetch when needed.
        if previousRequest?.imageRequest.urlRequest.url != request.imageRequest.urlRequest.url { fetch() }
        return GeometryReader {
            Group {
                if self.image != nil {
                    self.imageBody
                } else if self.placeholder != nil {
                    self.placeholder
                } else {
                    SwiftUI.Image.clear
                }
            }.frame(width: $0.size.width, height: $0.size.height)
        }
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
public extension PlaceholderNukeImage {
    /// Set `placeholder`.
    func placeholder(_ placeholder: SwiftUI.Image?) -> some NukeImageView  {
        NukeImage<Request>($request).placeholder(placeholder)
    }
    /// Set `placeholder`.
    func placeholder(_ placeholderImage: Nuke.Image?) -> some NukeImageView {
        NukeImage<Request>($request).placeholder(placeholderImage)
    }
    /// Set `placeholder`.
    func placeholder(_ placeholder: Placeholder?) -> some NukeImageView {
        var copy = self
        copy.placeholder = placeholder
        return copy
    }
}
