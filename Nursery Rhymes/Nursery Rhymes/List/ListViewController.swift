import Foundation
import UIKit
import Models
import Connection

final class ListViewController: UIViewController {
    private lazy var customView = ListView()
    private let dataSource: ListDataSourceInput
    private weak var appRouter: AppRouterInput?
    
    init(dataSource: ListDataSourceInput, appRouter: AppRouterInput?) {
        self.dataSource = dataSource
        self.appRouter = appRouter
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = ""
        navigationItem.titleView = customView.header
        dataSource.setup(tableView: customView.tableView)
        customView.refreshController.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
        dataSource.didSelectRow = {[weak self] item, _ in
            self?.appRouter?.showRhyme(model: item)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch()
    }
    
    private func fetch() {
        if dataSource.isEmpty {
            customView.showLoader()
        }
        dataSource.fetch { [weak self] anError in
            if let error = anError {
                self?.customView.showError(error: error)
            } else {
                self?.customView.successLoading()
            }
        }
    }
    
    @IBAction func onPullToRefresh() {
        fetch()
    }
    
    @available(*, unavailable, message: "init(coder:) has not been implemented, use init(dataSource:) intead")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


#if PREVIEW && canImport(SwiftUI)
import SwiftUI

class ListDataSourceDummy: ListDataSourceInput {
    
    
    var didSelectRow: ((ListViewModel, IndexPath) -> Void)? = nil
    
    let isEmpty: Bool = true
    
    func setup(tableView: UITableView) {}
    
    func fetch(complete: @escaping (Error?) -> Void) {
    }
    
    
}

struct ListViewControllerPreview: PreviewProvider {
    static var previews: some SwiftUI.View {
        Group {
            ListViewController(dataSource: ListDataSourceDummy(), appRouter: nil)
                .previewInNavigationController()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
                .previewDisplayName("Light mode")
            
            ListViewController(dataSource: ListDataSourceDummy(), appRouter: nil)
                .previewInNavigationController()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark mode")
        }
    }
}


#endif
