import Foundation
import UIKit

final class RhymeViewController: UIViewController {
    private lazy var customView = RhymeView()
    let viewModel: ListViewModel
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customView.render(model: viewModel)
        navigationItem.titleView = customView.header
        customView.refreshController.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
    }
    
    @IBAction func onPullToRefresh() {
        
    }
    
    @available(*, unavailable, message: "init(coder:) has not been implemented, use init(dataSource:) intead")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
