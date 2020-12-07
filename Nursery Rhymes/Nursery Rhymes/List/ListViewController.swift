import Foundation
import UIKit

final class ListViewController: UIViewController {
    private lazy var customView = ListView()
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = customView.header
    }
}


#if PREVIEW && canImport(SwiftUI)
import SwiftUI

struct ListViewControllerPreview: PreviewProvider {
    static var previews: some SwiftUI.View {
        Group {
            ListViewController()
                .previewInNavigationController()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
                .previewDisplayName("Light mode")
            ListViewController()
                .previewInNavigationController()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark mode")
        }
    }
}


#endif
