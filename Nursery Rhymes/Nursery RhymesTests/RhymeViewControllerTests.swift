import XCTest
import SnapshotTesting
import Models

@testable import Nursery_Rhymes

class RhymeViewControllerTests: XCTestCase {
    var sut: RhymeViewController!
    
    var singleRhymeProvider: SingleRhymeProviderSpy!
    var bookListProvider: BookListForRhymeProviderSpy!
    var imageDownloader: ImageDownloaderSpy!
    var appRouter: AppRouterSpy!
    var favouritesProvider: FavouritesProviderSpy!
    var listViewModel: ListViewModel!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        singleRhymeProvider = SingleRhymeProviderSpy()
        bookListProvider = BookListForRhymeProviderSpy()
        imageDownloader = ImageDownloaderSpy()
        appRouter = AppRouterSpy()
        favouritesProvider = FavouritesProviderSpy()
        
        listViewModel = ListViewModel(id: "five-little-ducks", title: "Five Little Ducks Went Swimming One Day", author: "Maciej Gad", image: ImagePromiseMock(success: UIImage(systemName: "wand.and.stars.inverse")!), isFavourite: true)
        
        let factory = RhymeViewControllerFactory(singleRhymeProvider: singleRhymeProvider, bookListProvider: bookListProvider, imageDownloader: imageDownloader, favouritesProvider: favouritesProvider, appRouter: appRouter)
        
        sut = factory.makeViewController(viewModel: listViewModel)
    }

    override func tearDownWithError() throws {
        sut = nil
        singleRhymeProvider = nil
        bookListProvider = nil
        imageDownloader = nil
        appRouter = nil
        favouritesProvider = nil
        listViewModel = nil
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
        XCTAssertEqual(singleRhymeProvider.fetchId, "five-little-ducks")
        XCTAssertEqual(bookListProvider.fetchId, "five-little-ducks")
    }
    
    func testLoadedData() {
        //given
        _ = sut.view
        singleRhymeProvider.result = .success(rhyme)
        bookListProvider.result = .success(BookListForRhyme(rhymeId: "five-little-ducks", books: []))

        //when
        sut.viewWillAppear(false)
        sut.viewDidAppear(false)

        //then
        let nc = NavigationController(rootViewController: sut)
        assertSnapshot(matching: nc, as: .image)
    }
    
    func testErrorLoaded() {
        //given
        _ = sut.view
        singleRhymeProvider.result = .success(rhyme)
        bookListProvider.result = .failure(.emptyResponse)

        //when
        sut.viewWillAppear(false)
        sut.viewDidAppear(false)

        //then
        let nc = NavigationController(rootViewController: sut)
        assertSnapshot(matching: nc, as: .image)
    }
    
    func testShowingBooks() {
        //given
        let view = sut.view
        singleRhymeProvider.result = .success(rhyme)
        bookListProvider.result = .success(BookListForRhyme(rhymeId: "five-little-ducks", books: [
            Book(id: "a", title: "A book", author: nil, coverImage: nil, url: URL(string: "https://testing.io")!)
        ]))

        //when
        sut.viewWillAppear(false)
        sut.viewDidAppear(false)
        guard let button = view?.firstButton(title: "Buy book with this rhyme") else {
            XCTFail("Can't find button")
            return
        }
        button.sendActions(for: .touchUpInside)
        
        //then
        XCTAssertEqual(appRouter.showBooksList?.count, 1)
        XCTAssertEqual(appRouter.showBooksList?.first?.id, "a")
    }
}

fileprivate let rhyme = Rhyme(id: "five-little-ducks", title: "Five Little Ducks Went Swimming One Day", author: "Maciej Gad", text: rhymeText, image: URL(string: "https://placeducky.com/real/281/276.png"))

fileprivate let rhymeText = """
Five little ducks went swimming one day,
Over the hills and far away,
And Mummy Duck said “Quack, quack, quack”
But only four little ducks came back.
"""
