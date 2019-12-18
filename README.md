# NukeImage
![Travis (.com)](https://img.shields.io/travis/com/sbertix/NukeImage)
![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/sbertix/NukeImage)
[![GitHub](https://img.shields.io/github/license/sbertix/NukeImage)](https://github.com/sbertix/NukeImage/blob/master/LICENSE)
![Platform](https://img.shields.io/cocoapods/p/SwiftyInsta.svg?style=flat)
<img src="https://img.shields.io/badge/supports-Swift%20Package%20Manager-ff69b4.svg">  

**NukeImage** is a simple **SwiftUI** implementation for [**Nuke**](https://github.com/kean/Nuke.git).  
Simply pass your `URL` to `NukeImage` and you're ready to go.

## Installation
### Swift Package Manager (Xcode 11 and above)
1. Select `File`/`Swift Packages`/`Add Package Dependency…` from the menu.
1. Paste `https://github.com/sbertix/NukeImage.git`.
1. Follow the steps.

**NukeImage** depends on [**Nuke**](https://github.com/kean/Nuke.git).

## Usage
```swift
import NukeImage
import SwiftUI

struct YourView: View {
    let url: URL  // your content url.
    
    var body: some View {
        NukeImage(url)                // or pass an `ImageRequest` or `URLRquest` for finer control.
          .placeholder(Color(.systemGroupedBackground)) // optional.
          .resizable()                // fully supported.  optional.
          .renderingMode(.original)   // fully supported.  optional.
    }
}                      
```

In `NukeImage` `2.0`, performances are greatly improved when passing `Image`, `NSImage` or `UIImage` placeholders.  

## License
**NukeImage** is licensed under the MIT license.  
Check out [LICENSE](https://github.com/sbertix/NukeImage/blob/master/LICENSE) for more info.
