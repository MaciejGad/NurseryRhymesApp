import Foundation
import UIKit

extension UIView {
    func pinToSuperview(margin: UIEdgeInsets = .zero, safeArea: Bool = false) -> [NSLayoutConstraint] {
        guard let superview = self.superview else {
            assertionFailure("Add \(self) as subview")
            return []
        }
        let anchors: Anchors = (safeArea ? superview.safeAreaLayoutGuide : superview)
        return [
            leadingAnchor.constraint(equalTo: anchors.leadingAnchor, constant: margin.left),
            topAnchor.constraint(equalTo: anchors.topAnchor, constant: margin.top),
            trailingAnchor.constraint(equalTo: anchors.trailingAnchor, constant: -margin.right),
            bottomAnchor.constraint(equalTo: anchors.bottomAnchor, constant: -margin.bottom)
        ]
    }
}

protocol Anchors: class {
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    
    var leftAnchor: NSLayoutXAxisAnchor { get }
    var rightAnchor: NSLayoutXAxisAnchor { get }
    
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
}

extension UIView: Anchors {}
extension UILayoutGuide: Anchors {}
