//
//  Nursery_RhymesUITests.swift
//  Nursery RhymesUITests
//
//  Created by Maciej Gad on 06/12/2020.
//

import XCTest

class Nursery_RhymesUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAppFlow() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        app.tables.staticTexts["THE THREE CHILDREN"].tap()
        XCTAssertTrue(app.navigationBars["THE THREE CHILDREN"].exists)
        
        app.scrollViews.otherElements.staticTexts["Buy book with this rhyme"].tap()

        
        XCTAssertTrue(app.staticTexts["Books"].exists)
        app.navigationBars["Books"].buttons["close"].tap()
        app.navigationBars["THE THREE CHILDREN"].buttons["Back"].tap()
        
    }
    
    func testFilter() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launchArguments.append("RESET_FAVOURITES")
        app.launch()
        XCTAssertEqual(app.tables.cells.count, 5)
        app.tables.cells.staticTexts["THE THREE CHILDREN"].tap()
        
        let detailsNavigationBar = app.navigationBars["THE THREE CHILDREN"]
        detailsNavigationBar.buttons["love"].tap()
        detailsNavigationBar.buttons["Back"].tap()
        app.navigationBars["Nursery Rhymes"].buttons["love"].tap()
        XCTAssertEqual(app.tables.cells.count, 1)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
