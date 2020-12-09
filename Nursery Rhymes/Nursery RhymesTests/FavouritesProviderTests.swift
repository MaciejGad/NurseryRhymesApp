import XCTest

@testable import Nursery_Rhymes

class FavouritesProviderTests: XCTestCase {
    
    var sut: FavouritesProvider!
    var localDataProvider: LocalDataProviderSpy!
    
    override func setUpWithError() throws {
        localDataProvider = LocalDataProviderSpy()
        sut = FavouritesProvider(localDataProvider: localDataProvider)
    }

    override func tearDownWithError() throws {
        sut = nil
        localDataProvider = nil
    }

    func testLoadData() throws {
        //given
        guard let json = #"["123"]"#.data(using: .utf8) else {
            XCTFail("Can't load json")
            return
        }
        localDataProvider.givenData = .success(json)
        
        //when
        var anOutput: FavouritesList?
        sut.load { (list) in
            anOutput = list
        }
        
        //then
        let output = try XCTUnwrap(anOutput)
        XCTAssertTrue(output.contains("123"))
        XCTAssertEqual(localDataProvider.dataFilename, "favourites.json")
    }

    func testIsFavourite() throws {
        //given
        guard let json = #"["123"]"#.data(using: .utf8) else {
            XCTFail("Can't load json")
            return
        }
        localDataProvider.givenData = .success(json)
        
        //when
        var anOutput: Bool?
        sut.isFavourite(id: "123") { isFavourite in
            anOutput = isFavourite
        }
        
        //then
        let output = try XCTUnwrap(anOutput)
        XCTAssertTrue(output)
        XCTAssertEqual(localDataProvider.dataFilename, "favourites.json")
    }
    
    func testAddToFavourites() throws {
        //given
        guard let json = #"["123"]"#.data(using: .utf8) else {
            XCTFail("Can't load json")
            return
        }
        localDataProvider.givenData = .success(json)
        localDataProvider.givenSaveSuccess = true
        //when
        var completeCalled: Bool = false
        sut.addToFavourites(id: "124") { (error) in
            completeCalled = true
            XCTAssertNil(error)
        }
        
        //then
        XCTAssertTrue(completeCalled)
        XCTAssertEqual(localDataProvider.dataFilename, "favourites.json")
        let responseData = try XCTUnwrap(localDataProvider.saveData)
        let jsonDecoder = JSONDecoder()
        let list = try jsonDecoder.decode(FavouritesList.self, from: responseData)
        XCTAssertTrue(list.contains("123"))
        XCTAssertTrue(list.contains("124"))
    }
    
    func testRemoveFromFavourites() throws {
        //given
        guard let json = #"["123", "124"]"#.data(using: .utf8) else {
            XCTFail("Can't load json")
            return
        }
        localDataProvider.givenData = .success(json)
        localDataProvider.givenSaveSuccess = true
        //when
        var completeCalled: Bool = false
        sut.removeFromFavourites(id: "124") { (error) in
            completeCalled = true
            XCTAssertNil(error)
        }
        
        //then
        XCTAssertTrue(completeCalled)
        XCTAssertEqual(localDataProvider.dataFilename, "favourites.json")
        let responseData = try XCTUnwrap(localDataProvider.saveData)
        let jsonDecoder = JSONDecoder()
        let list = try jsonDecoder.decode(FavouritesList.self, from: responseData)
        XCTAssertTrue(list.contains("123"))
        XCTAssertFalse(list.contains("124"))
    }
}
