import Foundation
import UIKit

final class RhymeViewController: UIViewController {
    private lazy var customView = RhymeView()
    private let viewModel: ListViewModel
    private let detailsProvider: RhymeDetailsProviderInput
    
    init(viewModel: ListViewModel, detailsProvider: RhymeDetailsProviderInput) {
        self.viewModel = viewModel
        self.detailsProvider = detailsProvider
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customView.showLoader()
        fetch()
    }
    
    private func fetch() {
        detailsProvider.fetch(id: viewModel.id) { [weak self] result in
            switch result {
            case .success(let model):
                self?.customView.successLoading(model: model)
            case .failure(let error):
                self?.customView.showError(error: error)
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
