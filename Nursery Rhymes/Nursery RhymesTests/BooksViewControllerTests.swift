import XCTest
import SnapshotTesting
import Models

@testable import Nursery_Rhymes

class BooksViewControllerTests: XCTestCase {
    var sut: BooksViewController!
    var appRouter: AppRouterSpy!
    var books: [BookViewModel]!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        appRouter = AppRouterSpy()
        let image = ImagePromiseMock(success: UIImage(systemName: "wand.and.stars.inverse")!)
        books = [
            BookViewModel(id: "five-little-ducks-books",
                       title: "Five Little Ducks Went Out One Day!",
                       author: "Margaret Bateson-Hill",
                       coverImage: image,
                       link: URL(string: "https://www.amazon.com/Five-Little-Ducks-Went-Out/dp/1857143957")!)
        ]
        
        let factory = BooksViewControllerFactory(appRouter: appRouter)
        sut = factory.makeViewController(models: books)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        appRouter = nil
        books = nil
    }
    
    func testViewDidLoad() {
        //given
        _ = sut.view

        //when
        sut.viewWillAppear(false)
        sut.viewDidAppear(false)

        //then
        let nc = NavigationController(rootViewController: sut)
        assertSnapshot(matching: nc, as: .image)
    }
}

