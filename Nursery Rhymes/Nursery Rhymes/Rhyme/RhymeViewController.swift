import Foundation
import UIKit

final class RhymeViewController: UIViewController {
    private lazy var customView = RhymeView()
    private let viewModel: ListViewModel
    private let detailsProvider: RhymeDetailsProviderInput
    private let favouritesProvider: FavouritesProviderInput
    private weak var appRouter: AppRouterInput?
    
    private lazy var isFavourite: Bool = viewModel.isFavourite {
        didSet {
            onFavouriteUpdate()
        }
    }
    
    private var detailsViewModel: RhymeDetailsViewModel?
    
    init(viewModel: ListViewModel,
         detailsProvider: RhymeDetailsProviderInput,
         favouritesProvider: FavouritesProviderInput,
         appRouter: AppRouterInput?) {
        self.viewModel = viewModel
        self.detailsProvider = detailsProvider
        self.favouritesProvider = favouritesProvider
        self.appRouter = appRouter
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
        customView.bookListButton.addTarget(self, action: #selector(showBooks), for: .touchUpInside)
        onFavouriteUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customView.showLoader()
        fetch()
    }
    
    private func fetch() {
        detailsProvider.fetch(listViewModel: viewModel) { [weak self] result in
            switch result {
            case .success(let model):
                self?.customView.successLoading(model: model)
                self?.detailsViewModel = model
            case .failure(let error):
                self?.customView.showError(error: error)
            }
        }
    }
    
    @IBAction func toggleFavourite() {
        if isFavourite {
            favouritesProvider.removeFromFavourites(id: viewModel.id) {[weak self] (error) in
                if error != nil {
                    self?.isFavourite = true
                }
            }
        } else {
            favouritesProvider.addToFavourites(id: viewModel.id) {[weak self] (error) in
                if error != nil {
                    self?.isFavourite = false
                }
            }
        }
        isFavourite.toggle()
    }
    
    private func onFavouriteUpdate() {
        let image = UIImage(systemName: isFavourite ? "heart.fill" : "heart")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(toggleFavourite))
    }
    
    @IBAction func onPullToRefresh() {
        fetch()
    }
    
    @IBAction func showBooks() {
        guard let bookList = detailsViewModel?.books else {
            return
        }
        appRouter?.showBooks(list: bookList)
    }
    
    @available(*, unavailable, message: "init(coder:) has not been implemented, use init(dataSource:) intead")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

