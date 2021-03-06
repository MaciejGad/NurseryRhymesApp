# NurseryRhymesApp
NurseryRhymesApp is an example application that displays a list of nursery rhymes, the full text of a single one, and a list of books that contain it. It is build using Xcode 12.2 and swift 5.3. It uses Swift Package Manager for managing dependencies. It can be run on the iPhone, iPad, or macOS (thanks to Catalyst). It supports iOS 13 and 14.

![App screenshot](https://raw.githubusercontent.com/MaciejGad/NurseryRhymesApp/main/Screenshot.png)


# Installation
Clone this repository, open `Nursery Rhymes.xcodeproj` file, and then go to File->Swift Package -> Resolve Package Versions 

# Dependencies
 - Models - https://github.com/MaciejGad/NurseryRhymesModels - list of models used inside the app
 - Connections - https://github.com/MaciejGad/NurseryRhymesConnection - network layer used in the app 
 - SnapshotTesting - https://github.com/pointfreeco/swift-snapshot-testing - used only in the unit test target for testing UIViewControllers

Models and Connections have a separate list of unit tests.

# Tests
App has both unit tests (with coverage over 60% of code) and sample UI tests that handle two flows: going through all application screens and filtering items. For tests running use iPhone 8 simulator with iOS 14.2, to better match snapshots.

# Previews
There are previews inside the app for every view. Thanks to the bridge between UIKit and SwiftUI, we can pack UIView (or UIViewController) and display it in canvas. 
You can write code similar to this one and see your layout without running the app:
```swift
final class ListView: UIView { 
//...
}

#if PREVIEW && canImport(SwiftUI)
import SwiftUI

struct ListViewPreview: PreviewProvider {
    static var previews: some SwiftUI.View {
        Group {
            ListView()
                .preview()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
                .previewDisplayName("Light mode")
            ListView()
                .preview()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark mode")
        }
    }
}


#endif
