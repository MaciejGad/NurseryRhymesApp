import Foundation

final class BooksViewControllerFactory {
    let appRouter: AppRouterInput
    
    init(appRouter: AppRouterInput) {
        self.appRouter = appRouter
    }
    
    func makeViewController(models: [BookViewModel]) -> BooksViewController {
        let dataSource = BooksDataSource(books: models)
        return BooksViewController(dataSource: dataSource, appRouter: appRouter)
    }
}
