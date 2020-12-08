import Foundation
import UIKit
import Models
import Connection

protocol AppRouterInput: class {
    func rootViewController() -> UIViewController
    func showRhyme(model: ListViewModel)
    func showBookList(for rhymeId: Rhyme.ID)
}


final class AppRouter: AppRouterInput {
    
    let listProvider: RhymeListProviderInput
    let detailsProvider: SingleRhymeProviderInput
    let bookListProvider: BookListForRhymeProviderInput
    let imageDownloader: ImageDownloaderInput
    
    init(listProvider: RhymeListProviderInput,
         detailsProvider: SingleRhymeProviderInput,
         bookListProvider: BookListForRhymeProviderInput,
         imageDownloader: ImageDownloaderInput) {
        self.listProvider = listProvider
        self.detailsProvider = detailsProvider
        self.bookListProvider = bookListProvider
        self.imageDownloader = imageDownloader
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
            imageDownloader: ImageDownloader(baseURL: baseImageURL))
        
    }
    lazy var navigationController = makeNavigationController()
    
    func rootViewController() -> UIViewController {
        navigationController
    }
    
    func showRhyme(model: ListViewModel) {
        let factory = RhymeViewControllerFactory(singleRhymeProvider: detailsProvider, bookListProvider: bookListProvider, imageDownloader: imageDownloader)
        let vc = factory.makeViewController(viewModel: model)
        navigationController.pushViewController(vc, animated: true)
    }
    
    
    func showBookList(for rhymeId: Rhyme.ID) {
        
    }
    
    
    private func makeNavigationController() -> UINavigationController {
        let listViewControllerFactory = ListViewControllerFactory(rhymeListProvider: listProvider, imageDownloader: imageDownloader, appRouter: self)
        return NavigationController(rootViewController: listViewControllerFactory.makeViewController())
    }
}
