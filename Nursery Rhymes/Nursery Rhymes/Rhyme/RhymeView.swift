import Foundation
import UIKit
import Models
import Connection

final class RhymeView: UIView {
    let header = UILabel()
    
    let coverImageView = UIImageView()
    let titleLabel = UILabel()
    let authorLabel = UILabel()
    let textLabel = UILabel()
    let bookListButton = UIButton()
    
    let loader = UIActivityIndicatorView(style: .large)
    let errorView = ErrorView()
    let scrollView = UIScrollView()
    let refreshController = UIRefreshControl()
    
    private var imageDownloadTask: Task? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    func render(model: ListViewModel) {
        header.text = model.title
        titleLabel.text = model.title
        if let author = model.author {
            authorLabel.text = author
            authorLabel.isHidden = false
        } else {
            authorLabel.isHidden = true
        }
        downloadImage(promise: model.image)
    }
    
    func showLoader() {
        errorView.isHidden = true
        loader.isHidden = false
        bookListButton.isHidden = true
        loader.startAnimating()
    }
    
    func showError(error: Error) {
        loader.isHidden = true
        //In real-life app I should better format the error message to be more readable for user
        errorView.titleLabel.text = "Error: \(error.localizedDescription)"
        errorView.isHidden = false
        bookListButton.isHidden = true
        refreshController.endRefreshing()
    }
    
    func successLoading(model: RhymeDetailsViewModel) {
        errorView.isHidden = true
        loader.isHidden = true
        textLabel.text = model.text
        bookListButton.isHidden = false
        refreshController.endRefreshing()
    }
    
    private func downloadImage(promise: ImagePromiseInput?) {
        showFallback()
        imageDownloadTask = promise?.fetch {[ weak self] result in
            defer {
                self?.imageDownloadTask = nil
            }
            if case let .success(image) = result {
                self?.show(image: image)
            }
        }
    }
    
    private func show(image: UIImage) {
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.image = image
    }
    
    private func showFallback() {
        coverImageView.contentMode = .scaleAspectFit
        coverImageView.image = UIImage(systemName: "book.fill")
    }
    
    private func setup() {
        backgroundColor = .systemBackground
        header.translatesAutoresizingMaskIntoConstraints = false
        header.font = UIFont(name: "Zapfino", size: 9)
        header.textAlignment = .center
        header.textColor = .systemOrange
        
        let container = UIStackView(arrangedSubviews: [
            coverImageView,
            titleLabel,
            authorLabel,
            loader,
            errorView,
            textLabel,
            bookListButton,
            UIView()
        ])
        container.axis = .vertical
        container.spacing = 12
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.clipsToBounds = true
        coverImageView.tintColor = .systemOrange
        coverImageView.layer.cornerRadius = 4
        
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: "Cochin", size: 20)
        authorLabel.numberOfLines = 0
        authorLabel.font = UIFont(name: "Cochin", size: 15)
        authorLabel.textColor = .systemGreen
        
        textLabel.numberOfLines = 0
        textLabel.font = UIFont(name: "Cochin", size: 18)
        textLabel.textAlignment = .center
        errorView.isHidden = true
        
        bookListButton.isHidden = true
        bookListButton.setTitle("Buy book with this rhyme", for: .normal)
        bookListButton.setTitleColor(.systemOrange, for: .normal)
        bookListButton.layer.borderWidth = 1
        bookListButton.layer.borderColor = UIColor.systemOrange.cgColor
        bookListButton.layer.cornerRadius = 4
        
        container.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(container)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        scrollView.addSubview(refreshController)
        makeConstraints(container: container)
    }
    
    private func makeConstraints(container: UIStackView) {
        let additionalConstraints = [
            container.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -16),
            container.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor, constant: 0),
            coverImageView.heightAnchor.constraint(equalTo: coverImageView.widthAnchor, multiplier: 0.5)
        ]
        let constraints = [
            scrollView.pinToSuperview(safeArea: true),
            container.pinToSuperview(margin: .init(top: 0, left: 8, bottom: 0, right: 8)),
            additionalConstraints
        ].flatMap { $0 }
        NSLayoutConstraint.activate(constraints)
    }
    
    

    @available(*, unavailable, message: "init(coder:) has not been implemented, use  init(frame:) intead")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#if PREVIEW && canImport(SwiftUI)
import SwiftUI

struct RhymeViewPreview: PreviewProvider {
    
    static func view(image: ImagePromiseInput, author: String? = nil) -> RhymeView {
        let view = RhymeView()
        
        let model = ListViewModel(id: "123", title: "This is a test", author: author, image: image, isFavourite: false)
        view.render(model: model)
        return view
    }
    
    static var previews: some SwiftUI.View {
        let promise = ImagePromiseMock(success: UIImage(systemName: "wand.and.stars.inverse")!)
        let failure = ImagePromiseMock(failure: .emptyResponse)
        
        let view1 = self.view(image: promise, author: "Maciej Gad")
        let view2 = self.view(image: failure)
        return Group {
            view1
                .preview()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
                .previewDisplayName("Light mode")
            view2
                .preview()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark mode")
        }
    }
}


#endif
