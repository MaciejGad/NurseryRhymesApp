import Foundation
import UIKit
import Models
import Connection

final class BookCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let coverImageView = UIImageView()

    private var imageDownloadTask: Task? = nil
    private var bookId: Book.ID? = nil
    
    static var cellReuseIdentifier = "BookCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    func render(model: BookViewModel) {
        bookId = model.id
        titleLabel.text = model.title
        if let author = model.author {
            authorLabel.text = author
            authorLabel.isHidden = false
        } else {
            authorLabel.isHidden = true
        }
        downloadImage(promise: model.coverImage, modelId: model.id)
    }
    
    private func downloadImage(promise: ImagePromiseInput?, modelId: Book.ID) {
        showFallback()
        imageDownloadTask = promise?.fetch {[ weak self] result in
            defer {
                self?.imageDownloadTask = nil
            }
            guard let id = self?.bookId, modelId == id else {
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
        
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: "Cochin", size: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        authorLabel.numberOfLines = 0
        authorLabel.font = UIFont(name: "Cochin", size: 15)
        authorLabel.textColor = .systemGreen
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(authorLabel)
        makeConstraints()
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            
            //coverImageView
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            coverImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -4),
            coverImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.2),
            coverImageView.heightAnchor.constraint(equalToConstant: 100),
            
            //titleLabel
            titleLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            //authorLabel
            authorLabel.leadingAnchor.constraint(equalTo: coverImageView.trailingAnchor, constant: 8),
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            authorLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -4),
        ])
    }
    
    @available(*, unavailable, message: "init(coder:) has not been implemented, use init(style:reuseIdentifier:) intead")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#if PREVIEW && canImport(SwiftUI)
import SwiftUI

struct BookCellPreview: PreviewProvider {
    static func cell(image: ImagePromiseInput, author: String? = nil) -> BookCell {
        let cell = BookCell()
        let model = BookViewModel(id: "123", title: "101 Nursery Rhymes & Sing-Along Songs for Kids", author: author, coverImage: image, link: URL(string: "https://test.io")!)
        cell.render(model: model)
        return cell
    }
    
    static var previews: some SwiftUI.View {
        let promise = ImagePromiseMock(success: UIImage(systemName: "wand.and.stars.inverse")!)
        let failure = ImagePromiseMock(failure: .emptyResponse)
        
        let listCell = self.cell(image: promise, author: "Maciej Gad")
        let listCell2 = self.cell(image: failure)
        
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

