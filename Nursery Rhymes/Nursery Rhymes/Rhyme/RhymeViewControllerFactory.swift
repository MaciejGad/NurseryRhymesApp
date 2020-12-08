import Foundation
import Connection

final class RhymeViewControllerFactory {
    let singleRhymeProvider: SingleRhymeProviderInput
    let bookListProvider: BookListForRhymeProviderInput
    let imageDownloader: ImageDownloaderInput
    
    init(singleRhymeProvider: SingleRhymeProviderInput, bookListProvider: BookListForRhymeProviderInput, imageDownloader: ImageDownloaderInput) {
        self.singleRhymeProvider = singleRhymeProvider
        self.bookListProvider = bookListProvider
        self.imageDownloader = imageDownloader
    }
    
    func makeViewController(viewModel: ListViewModel) -> RhymeViewController {
        let detailsProvider = RhymeDetailsProvider(singleRhymeProvider: singleRhymeProvider, bookListProvider: bookListProvider, imageDownloader: imageDownloader)
        return RhymeViewController(viewModel: viewModel, detailsProvider: detailsProvider)
    }
}
