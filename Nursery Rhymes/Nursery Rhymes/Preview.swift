import Foundation
import UIKit

#if PREVIEW && canImport(SwiftUI)
import SwiftUI

struct Preview<Content: UIView>: UIViewRepresentable {
 
    let makeContent: () -> Content
    
    init(_ makeContent: @escaping @autoclosure () -> Content) {
        self.makeContent = makeContent
    }
    
    func makeUIView(context: Context) -> Content {
        makeContent()
    }
    
    func updateUIView(_ uiView: Content, context: Context) {}
}

extension UIView {
    func preview() -> Preview<UIView> {
        Preview(self)
    }
    
    func previewSizeThatFits(width: CGFloat = 320, border: Bool = false) -> some View {
        let container = UIViewController()
        translatesAutoresizingMaskIntoConstraints = false
        container.view.addSubview(self)

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: container.view.leadingAnchor),
            trailingAnchor.constraint(equalTo: container.view.trailingAnchor),
            topAnchor.constraint(equalTo: container.view.topAnchor),
            heightAnchor.constraint(equalToConstant: 100).with(\.priority, .defaultLow),
        ])
        if border {
            self.layer.borderColor = UIColor.red.cgColor
            self.layer.borderWidth = 1
        }
        container.view.setNeedsLayout()
        container.view.layoutIfNeeded()
        return container
            .preview()
            .previewLayout(.fixed(width: width, height: frame.height))
    }
}

struct PreviewViewController<Content: UIViewController>: UIViewControllerRepresentable {
    
    let makeContent: () -> Content
    
    init(_ makeContent: @escaping @autoclosure () -> Content) {
        self.makeContent = makeContent
    }
    
    func makeUIViewController(context: Context) -> Content {
        makeContent()
    }

    func updateUIViewController(_ uiViewController: Content, context: Context) {}
}

extension UIViewController {
    func preview() -> PreviewViewController<UIViewController> {
        PreviewViewController(self)
    }
    
    func previewInNavigationController() -> some View {
        let container = UINavigationController(rootViewController: self)
        return container.preview()
    }
}

#endif
