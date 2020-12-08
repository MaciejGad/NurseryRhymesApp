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
    let imageDownloader: ImageDownloaderInput
    
    init(listProvider: RhymeListProviderInput, imageDownloader: ImageDownloaderInput) {
        self.listProvider = listProvider
        self.imageDownloader = imageDownloader
    }
    
    convenience init() {
        self.init(
            listProvider: RhymeListProvider(baseURL: URL(string: "https://maciejgad.github.io/NurseryRhymesJSON/data/")!),
            imageDownloader: ImageDownloader(baseURL: URL(string: "https://maciejgad.github.io/NurseryRhymesJSON/images/")!))
        
    }
    lazy var navigationController = makeNavigationController()
    
    func rootViewController() -> UIViewController {
        navigationController
    }
    
    func showRhyme(model: ListViewModel) {
        let factory = RhymeViewControllerFactory()
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
