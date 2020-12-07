import Foundation
import XCTest
import SnapshotTesting

@testable import Nursery_Rhymes

class ListViewControllerTests: XCTestCase {
    var sut: ListViewController!
    
    override func setUpWithError() throws {
        sut = ListViewController()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testViewDidLoad() {
        assertSnapshot(matching: sut, as: .image)
    }
    
    func testViewControllerInsideNavigationController() {
        let nc = UINavigationController(rootViewController: sut)
        assertSnapshot(matching: nc, as: .image)
    }
}
