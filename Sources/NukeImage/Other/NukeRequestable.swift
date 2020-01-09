//
//  File.swift
//  
//
//  Created by Stefano Bertagno on 17/12/2019.
//

import Foundation
import Nuke

public protocol NukeRequestable: Equatable {
    /// Create an `ImageRequest`.
    var imageRequest: ImageRequest { get }
}
extension ImageRequest: NukeRequestable {
    public var imageRequest: ImageRequest { self }
}
extension URL: NukeRequestable {
    public var imageRequest: ImageRequest { ImageRequest(url: self) }
}
extension URLRequest: NukeRequestable {
    public var imageRequest: ImageRequest { ImageRequest(urlRequest: self) }
}
extension ImageRequest: Equatable {
    public static func == (lhs: ImageRequest, rhs: ImageRequest) -> Bool {
        lhs.urlRequest == rhs.urlRequest
    }
}
