import Foundation
import Models
import Connection

final class ListViewControllerFactory {
    let rhymeListProvider: RhymeListProviderInput
    let imageDownloader: ImageDownloaderInput
    let appRouter: AppRouterInput
    let favouritesProvider: FavouritesProviderInput
    
    init(rhymeListProvider: RhymeListProviderInput,
         imageDownloader: ImageDownloaderInput,
         appRouter: AppRouterInput,
         favouritesProvider: FavouritesProviderInput) {
        self.rhymeListProvider = rhymeListProvider
        self.imageDownloader = imageDownloader
        self.appRouter = appRouter
        self.favouritesProvider = favouritesProvider
    }
    
    func makeViewController() -> ListViewController {
        let dataSource = ListDataSource(rhymeListProvider: rhymeListProvider, imageDownloader: imageDownloader, favouritesProvider: favouritesProvider)
        return ListViewController(dataSource: dataSource, appRouter: appRouter)
    }
}
