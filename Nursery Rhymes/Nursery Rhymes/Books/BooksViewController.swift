import Foundation
import UIKit

final class BooksViewController: UIViewController {
    private lazy var customView = BooksView()
    
    private let dataSource: BooksDataSource
    private weak var appRouter: AppRouterInput?
    
    init(dataSource: BooksDataSource, appRouter: AppRouterInput?) {
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(hide))
        dataSource.setup(tableView: customView.tableView)
        dataSource.didSelectRow = { [weak self] item, _ in
            self?.appRouter?.showBookInBrowser(url: item.link)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.dataSource.showBooks()
        }
    }
    
    @IBAction func hide() {
        dismiss(animated: true)
    }
    
    @available(*, unavailable, message: "init(coder:) has not been implemented, use init(dataSource:) intead")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


