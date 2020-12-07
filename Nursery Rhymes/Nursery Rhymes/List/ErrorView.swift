import Foundation
import UIKit

final class ErrorView: UIView {
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        titleLabel.text = "Error loading"
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: "Cochin", size: 16)
        titleLabel.textColor = .systemRed
        makeConstraints()
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @available(*, unavailable, message: "init(coder:) has not been implemented, use  init(frame:) intead")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



#if PREVIEW && canImport(SwiftUI)
import SwiftUI

struct ErrorViewPreview: PreviewProvider {
    static var previews: some SwiftUI.View {
        Group {
            ErrorView()
                .previewSizeThatFits(width: 150, border: true)
                .preferredColorScheme(.light)
                .previewDisplayName("Light mode")
            ErrorView()
                .previewSizeThatFits()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark mode")
        }
    }
}


#endif
