import Foundation
import Models
import Connection

final class ListViewControllerFactory {
    let rhymeListProvider: RhymeListProviderInput
    let imageDownloader: ImageDownloaderInput
    let appRouter: AppRouterInput
    
    init(rhymeListProvider: RhymeListProviderInput, imageDownloader: ImageDownloaderInput, appRouter: AppRouterInput) {
        self.rhymeListProvider = rhymeListProvider
        self.imageDownloader = imageDownloader
        self.appRouter = appRouter
    }
    
    func makeViewController() -> ListViewController {
        let dataSource = ListDataSource(rhymeListProvider: rhymeListProvider, imageDownloader: imageDownloader)
        return ListViewController(dataSource: dataSource, appRouter: appRouter)
    }
}
