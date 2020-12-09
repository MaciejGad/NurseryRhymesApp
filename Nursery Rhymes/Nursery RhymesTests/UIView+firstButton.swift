import Foundation
import UIKit

extension UIView {
    func firstButton(title: String) -> UIButton? {
        var allSubview: [UIView] = self.subviews
        while !allSubview.isEmpty {
            guard let view = allSubview.popLast() else {
                break
            }
            if let button = view as? UIButton {
                if button.title(for: .normal) == title {
                    return button
                }
            } else {
                allSubview.append(contentsOf: view.subviews)
            }
        }
        return nil
    }
}
