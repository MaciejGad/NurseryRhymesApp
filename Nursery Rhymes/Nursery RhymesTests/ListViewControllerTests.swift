import Foundation
import XCTest
import SnapshotTesting
import Models

@testable import Nursery_Rhymes

class ListViewControllerTests: XCTestCase {
    var sut: ListViewController!
    var rhymeListProvider: RhymeListProviderSpy!
    var imageDownloader: ImageDownloaderSpy!
    var appRouter: AppRouterSpy!
    var favouritesProvider: FavouritesProviderSpy!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        rhymeListProvider = RhymeListProviderSpy()
        imageDownloader = ImageDownloaderSpy()
        appRouter = AppRouterSpy()
        favouritesProvider = FavouritesProviderSpy()
        let factory = ListViewControllerFactory(rhymeListProvider: rhymeListProvider, imageDownloader: imageDownloader, appRouter: appRouter, favouritesProvider: favouritesProvider)
        sut = factory.makeViewController()
        UIView.setAnimationsEnabled(false)
    }

    override func tearDownWithError() throws {
        sut = nil
        rhymeListProvider = nil
        imageDownloader = nil
        appRouter = nil
        favouritesProvider = nil
    }

    func testViewDidLoad() {
        assertSnapshot(matching: sut, as: .image)
        XCTAssertTrue(rhymeListProvider.fetchListCalled)
        XCTAssertTrue(favouritesProvider.loadCalled)
    }
    
    func testLoadedData() {
        //given
        let givenList = List(results: [
            rhyme.toListItem()
        ])
        rhymeListProvider.result = .success(givenList)
        favouritesProvider.givenList = []
        
        //when
        _ = sut.view
        sut.viewWillAppear(false)
        sut.viewDidAppear(false)
        
        //then
        let nc = NavigationController(rootViewController: sut)
        assertSnapshot(matching: nc, as: .image)
    }
    
    func testFavouriteLoadedData() {
        //given
        let givenList = List(results: [
            rhyme.toListItem()
        ])
        rhymeListProvider.result = .success(givenList)
        favouritesProvider.givenList = ["five-little-ducks"]
        
        //when
        _ = sut.view
        sut.viewWillAppear(false)
        sut.viewDidAppear(false)
        
        //then
        let nc = NavigationController(rootViewController: sut)
        assertSnapshot(matching: nc, as: .image)
    }
    
    func testViewControllerInsideNavigationController() {
        let nc = NavigationController(rootViewController: sut)
        assertSnapshot(matching: nc, as: .image)
    }
    
}

fileprivate let rhyme = Rhyme(id: "five-little-ducks", title: "Five Little Ducks Went Swimming One Day", author: "Maciej Gad", text: "", image: URL(string: "https://placeducky.com/real/281/276.png"))
