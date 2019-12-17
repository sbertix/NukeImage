//
//  File.swift
//  
//
//  Created by Stefano Bertagno on 17/12/2019.
//

import Foundation
import Nuke

public protocol NukeRequestable {
    /// Create an `ImageRequest`.
    func imageRequest() -> ImageRequest
}
extension ImageRequest: NukeRequestable {
    public func imageRequest() -> ImageRequest { self }
}
extension URL: NukeRequestable {
    public func imageRequest() -> ImageRequest { ImageRequest(url: self) }
}
extension URLRequest: NukeRequestable {
    public func imageRequest() -> ImageRequest { ImageRequest(urlRequest: self) }
}
