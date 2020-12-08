import Foundation
import UIKit

extension UIView {
    func pinToSuperview(margin: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        guard let superview = self.superview else {
            assertionFailure("Add \(self) as subview")
            return []
        }
        return [
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: margin.left),
            topAnchor.constraint(equalTo: superview.topAnchor, constant: margin.top),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -margin.right),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -margin.bottom)
        ]
    }
}
