import Foundation
import UIKit
import Models
import Connection

protocol AppRouterInput: class {
    func rootViewController() -> UIViewController
    func showRhyme(model: ListViewModel)
    func showBooks(list: [BookViewModel])
    func showBookInBrowser(url: URL)
}


final class AppRouter: AppRouterInput {
    
    let listProvider: RhymeListProviderInput
    let detailsProvider: SingleRhymeProviderInput
    let bookListProvider: BookListForRhymeProviderInput
    let imageDownloader: ImageDownloaderInput
    let favouritesProvider: FavouritesProviderInput
    
    init(listProvider: RhymeListProviderInput,
         detailsProvider: SingleRhymeProviderInput,
         bookListProvider: BookListForRhymeProviderInput,
         imageDownloader: ImageDownloaderInput,
         favouritesProvider: FavouritesProviderInput) {
        self.listProvider = listProvider
        self.detailsProvider = detailsProvider
        self.bookListProvider = bookListProvider
        self.imageDownloader = imageDownloader
        self.favouritesProvider = favouritesProvider
    }
    
    convenience init() {
        guard let baseJsonURL = URL(string: "https://maciejgad.github.io/NurseryRhymesJSON/data/") else {
            fatalError("Wrong base url!")
        }
        guard let baseImageURL = URL(string: "https://maciejgad.github.io/NurseryRhymesJSON/images/") else {
            fatalError("Wrong base url!")
        }
        self.init(
            listProvider: RhymeListProvider(baseURL: baseJsonURL),
            detailsProvider: SingleRhymeProvider(baseURL: baseJsonURL),
            bookListProvider: BookListForRhymeProvider(baseURL: baseJsonURL),
            imageDownloader: ImageDownloader(baseURL: baseImageURL),
            favouritesProvider: FavouritesProvider(localDataProvider: LocalDataProvider()))
        
    }
    lazy var navigationController = makeNavigationController()
    
    func rootViewController() -> UIViewController {
        #if DEBUG
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            return UIViewController()
        }
        #endif
        return navigationController
    }
    
    func showRhyme(model: ListViewModel) {
        let factory = RhymeViewControllerFactory(singleRhymeProvider: detailsProvider, bookListProvider: bookListProvider, imageDownloader: imageDownloader, favouritesProvider: favouritesProvider, appRouter: self)
        let vc = factory.makeViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
    }
    
    
    func showBooks(list: [BookViewModel]) {
        let factory = BooksViewControllerFactory(appRouter: self)
        let vc = factory.makeViewController(models: list)
        let nc = NavigationController(rootViewController: vc)
        navigationController.safePresent(nc, animated: true)
    }
    
    func showBookInBrowser(url: URL) {
        let factory = BrowserFactory()
        let vc = factory.makeViewController(url: url)
        navigationController.safePresent(vc, animated: true)
    }
    
    private func makeNavigationController() -> UINavigationController {
        let listViewControllerFactory = ListViewControllerFactory(rhymeListProvider: listProvider, imageDownloader: imageDownloader, appRouter: self, favouritesProvider: favouritesProvider)
        return NavigationController(rootViewController: listViewControllerFactory.makeViewController())
    }
}
