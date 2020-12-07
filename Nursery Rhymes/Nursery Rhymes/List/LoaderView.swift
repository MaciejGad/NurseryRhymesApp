import Foundation
import UIKit

final class LoaderView: UIView {
    let titleLabel = UILabel()
    let loaderView = UIActivityIndicatorView(style: .large)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        titleLabel.text = "Please wait. \nLoading..."
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: "Cochin", size: 16)
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loaderView)
        loaderView.startAnimating()
        makeConstraints()
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            loaderView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            loaderView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomAnchor.constraint(equalTo: loaderView.bottomAnchor, constant: 8)
        ])
    }
    
    @available(*, unavailable, message: "init(coder:) has not been implemented, use  init(frame:) intead")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



#if PREVIEW && canImport(SwiftUI)
import SwiftUI

struct LoaderViewPreview: PreviewProvider {
    static var previews: some SwiftUI.View {
        Group { 
            LoaderView()
                .previewSizeThatFits()
                .preferredColorScheme(.light)
                .previewDisplayName("Light mode")
            LoaderView()
                .previewSizeThatFits()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark mode")
        }
    }
}


#endif
