import Foundation
import UIKit
import Models
import Connection

struct ListCellViewModel {
    let id: Rhyme.ID
    let title: String
    let author: String?
    let image: ImagePromiseInput
    let isFavourite: Bool
}

final class ListCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let coverImageView = UIImageView()
    private let favouriteView = UIImageView()

    private var imageDownloadTask: Task? = nil
    private var rhymeId: Rhyme.ID? = nil
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    func render(model: ListCellViewModel) {
        rhymeId = model.id
        titleLabel.text = model.title
        if let author = model.author {
            authorLabel.text = author
            authorLabel.isHidden = false
        } else {
            authorLabel.isHidden = true
        }
        let favouriteImage: UIImage?
        if model.isFavourite {
            favouriteImage = UIImage(systemName: "heart.fill")
        } else {
            favouriteImage = UIImage(systemName:"heart")
        }
        favouriteView.image = favouriteImage
        downloadImage(promise: model.image, modelId: model.id)
    }
    
    private func downloadImage(promise: ImagePromiseInput, modelId: Rhyme.ID) {
        imageDownloadTask = promise.fetch {[ weak self] result in
            guard let id = self?.rhymeId, modelId == id else {
                return
            }
            switch result {
            case .success(let image):
                self?.coverImageView.contentMode = .scaleAspectFill
                self?.coverImageView.image = image
            case .failure:
                self?.coverImageView.contentMode = .scaleAspectFit
                self?.coverImageView.image = UIImage(systemName: "book.fill")
            }
            self?.imageDownloadTask = nil
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageDownloadTask?.cancel()
    }
    
    private func setup() {
        let titleStack = UIStackView(arrangedSubviews: [
            titleLabel,
            authorLabel
        ])
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: "Cochin", size: 18)
        authorLabel.numberOfLines = 0
        authorLabel.font = UIFont(name: "Cochin", size: 15)
        authorLabel.textColor = .systemGreen
        
        titleStack.axis = .vertical
        titleStack.spacing = 2
        let stack = UIStackView(arrangedSubviews: [
            coverImageView,
            titleStack,
            favouriteView
        ])
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.clipsToBounds = true
        coverImageView.tintColor = .systemOrange
        favouriteView.contentMode = .center
        favouriteView.tintColor = .systemRed
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)
        makeConstraints(body: stack)
    }
    
    private func makeConstraints(body: UIStackView) {
        NSLayoutConstraint.activate([
            body.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            body.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            body.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            body.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            coverImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            favouriteView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            favouriteView.widthAnchor.constraint(equalTo: favouriteView.heightAnchor),
            coverImageView.widthAnchor.constraint(equalTo: coverImageView.heightAnchor),
        ])
    }
    
    @available(*, unavailable, message: "init(coder:) has not been implemented, use init(style:reuseIdentifier:) intead")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#if PREVIEW && canImport(SwiftUI)
import SwiftUI

struct ListCellPreview: PreviewProvider {
    static func cell(image: ImagePromiseInput, isFavourite: Bool = true, author: String? = nil) -> ListCell {
        let cell = ListCell()
        
        let model = ListCellViewModel(id: "123", title: "This is a test", author: author, image: image, isFavourite: isFavourite)
        cell.render(model: model)
        return cell
    }
    
    static var previews: some SwiftUI.View {
        let promise = ImagePromiseMock(success: UIImage(systemName: "wand.and.stars.inverse")!)
        let failure = ImagePromiseMock(failure: .emptyResponse)
        
        let listCell = self.cell(image: promise, author: "Maciej Gad")
        let listCell2 = self.cell(image: failure, isFavourite: false, author: "Maciej Gad")
        
        return Group {
            listCell
                .previewSizeThatFits()
                .preferredColorScheme(.light)
                .previewDisplayName("Light mode")
            listCell2
                .previewSizeThatFits()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark mode")
        }
    }
}


#endif
