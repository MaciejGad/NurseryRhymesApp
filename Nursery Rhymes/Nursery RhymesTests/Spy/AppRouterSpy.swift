import Foundation
import UIKit

@testable import Nursery_Rhymes

class AppRouterSpy: AppRouterInput {
    
    var rootViewControllerGiven = UIViewController()
    var rootViewControllerCalled = false
    func rootViewController() -> UIViewController {
        rootViewControllerCalled = true
        return rootViewControllerGiven
    }
    
    var showRhymeModel: ListViewModel?
    func showRhyme(model: ListViewModel) {
        showRhymeModel = model
    }
    
    var showBooksList: [BookViewModel]?
    func showBooks(list: [BookViewModel]) {
        showBooksList = list
    }
    
    var showBookInBrowserUrl: URL?
    func showBookInBrowser(url: URL) {
        showBookInBrowserUrl = url
    }
}
