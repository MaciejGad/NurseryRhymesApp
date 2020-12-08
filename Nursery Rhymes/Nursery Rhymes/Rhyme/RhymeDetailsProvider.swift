import Foundation
import Models
import Connection

protocol RhymeDetailsProviderInput {
    func fetch(id: Rhyme.ID, completion: @escaping (Result<RhymeDetailsViewModel, ConnectionError>) -> Void)
}

final class RhymeDetailsProvider: RhymeDetailsProviderInput {
    let singleRhymeProvider: SingleRhymeProviderInput
    let bookListProvider: BookListForRhymeProviderInput
    let imageDownloader: ImageDownloaderInput
    
    init(singleRhymeProvider: SingleRhymeProviderInput,
            bookListProvider: BookListForRhymeProviderInput,
             imageDownloader: ImageDownloaderInput) {
        self.singleRhymeProvider = singleRhymeProvider
        self.bookListProvider = bookListProvider
        self.imageDownloader = imageDownloader
    }
    
    func fetch(id: Rhyme.ID, completion: @escaping (Result<RhymeDetailsViewModel, ConnectionError>) -> Void) {
        let aggregator = Aggregator<Rhyme, BookListForRhyme, ConnectionError> { [weak self] (result) in
            guard let stronSelf = self else { return }
            switch result {
            case .success((let rhyme, let bookList)):
                let model = stronSelf.createViewModel(rhyme: rhyme, bookList: bookList)
                completion(.success(model))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
        singleRhymeProvider.fetch(id: id) { result in
            aggregator.aResult = result
        }
        bookListProvider.fetch(id: id) { result in
            aggregator.bResult = result
        }
    }
    
    private func createViewModel(rhyme: Rhyme, bookList: BookListForRhyme) -> RhymeDetailsViewModel {
        let imagePromise = rhyme.image.asImagePromise(downloader: imageDownloader)
        let books = bookList.toBookViewModels(imageDownloader: imageDownloader)
        return .init(title: rhyme.title, author: rhyme.author, image: imagePromise, text: rhyme.text, books: books)
    }
    
    
}

extension BookListForRhyme {
    func toBookViewModels(imageDownloader: ImageDownloaderInput) -> [BookViewModel] {
        books.map {
            BookViewModel(id: $0.id,
                          title: $0.title,
                          author: $0.author,
                          coverImage: $0.coverImage.asImagePromise(downloader: imageDownloader),
                          link: $0.url)
        }

    }
}
