import Foundation
import Connection

final class RhymeViewControllerFactory {
    let singleRhymeProvider: SingleRhymeProviderInput
    let bookListProvider: BookListForRhymeProviderInput
    let imageDownloader: ImageDownloaderInput
    let favouritesProvider: FavouritesProviderInput
    
    init(singleRhymeProvider: SingleRhymeProviderInput,
         bookListProvider: BookListForRhymeProviderInput,
         imageDownloader: ImageDownloaderInput,
         favouritesProvider: FavouritesProviderInput) {
        self.singleRhymeProvider = singleRhymeProvider
        self.bookListProvider = bookListProvider
        self.imageDownloader = imageDownloader
        self.favouritesProvider = favouritesProvider
    }
    
    func makeViewController(viewModel: ListViewModel) -> RhymeViewController {
        let detailsProvider = RhymeDetailsProvider(singleRhymeProvider: singleRhymeProvider, bookListProvider: bookListProvider, imageDownloader: imageDownloader)
        return RhymeViewController(viewModel: viewModel, detailsProvider: detailsProvider, favouritesProvider: favouritesProvider)
    }
}
