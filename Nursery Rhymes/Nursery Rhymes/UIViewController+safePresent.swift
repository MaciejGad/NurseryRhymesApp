import Foundation
import UIKit

extension UIViewController {
    func safePresent(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if let presentedViewController = self.presentedViewController {
            presentedViewController.safePresent(viewControllerToPresent, animated: flag, completion: completion)
            return
        }
        present(viewControllerToPresent, animated: flag, completion: completion)
    }
}
