import Foundation
import UIKit
import Models
import Connection


final class ListCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let coverImageView = UIImageView()
    private let favouriteView = UIImageView()

    private var imageDownloadTask: Task? = nil
    private var rhymeId: Rhyme.ID? = nil
    
    static var cellReuseIdentifier = "ListCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    func render(model: ListViewModel) {
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
    
    private func downloadImage(promise: ImagePromiseInput?, modelId: Rhyme.ID) {
        showFallback()
        imageDownloadTask = promise?.fetch {[ weak self] result in
            defer {
                self?.imageDownloadTask = nil
            }
            guard let id = self?.rhymeId, modelId == id else {
                return
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageDownloadTask?.cancel()
    }
    
    private func setup() {
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.clipsToBounds = true
        coverImageView.tintColor = .systemOrange
        coverImageView.layer.cornerRadius = 4
        contentView.addSubview(coverImageView)
        
        
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
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleStack)
        
        favouriteView.translatesAutoresizingMaskIntoConstraints = false
        favouriteView.contentMode = .center
        favouriteView.tintColor = .systemRed
        contentView.addSubview(favouriteView)
        makeConstraints(titleStack: titleStack)
    }
    
    private func makeConstraints(titleStack: UIStackView) {
        NSLayoutConstraint.activate([
            
            //coverImageView
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            coverImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -4),
            coverImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2),
            coverImageView.heightAnchor.constraint(equalToConstant: 100),
            
            //titleStack
            titleStack.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 8),
            titleStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            titleStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            //favouriteView
            favouriteView.leadingAnchor.constraint(equalTo: titleStack.trailingAnchor, constant: 8),
            favouriteView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favouriteView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            favouriteView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.15),
            favouriteView.widthAnchor.constraint(equalTo: favouriteView.heightAnchor),
            
            
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
        
        let model = ListViewModel(id: "123", title: "This is a test", author: author, image: image, isFavourite: isFavourite)
        cell.render(model: model)
        return cell
    }
    
    static var previews: some SwiftUI.View {
        let promise = ImagePromiseMock(success: UIImage(systemName: "wand.and.stars.inverse")!)
        let failure = ImagePromiseMock(failure: .emptyResponse)
        
        let listCell = self.cell(image: promise, author: "Maciej Gad")
        let listCell2 = self.cell(image: failure, isFavourite: false)
        
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
