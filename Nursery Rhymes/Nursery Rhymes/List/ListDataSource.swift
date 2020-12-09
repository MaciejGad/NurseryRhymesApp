import Foundation
import Models
import Connection
import UIKit

fileprivate typealias TableViewDataSource = UITableViewDiffableDataSource<ListDataSource.Section, ListViewModel>

protocol ListDataSourceInput: class {
    var isEmpty: Bool { get }
    var didSelectRow: ((ListViewModel, IndexPath) -> Void)? { get set }
    func setup(tableView: UITableView)
    func fetch(complete: @escaping (Error?) -> Void)
    func filter(favouritesOnly: Bool)
}

final class ListDataSource: ListDataSourceInput {
    enum Section: CaseIterable {
        case rhymes
    }
    
    private var dataSource: TableViewDataSource?
    private var tableView: UITableView?
    private var tableDelegate: Delegate?
    
    let rhymeListProvider: RhymeListProviderInput
    let imageDownloader: ImageDownloaderInput
    let favouritesProvider: FavouritesProviderInput
    
    private var list: List? = nil
    private var favourites: FavouritesList? = nil
    private var favouritesOnly: Bool = false
    
    var didSelectRow: ((ListViewModel, IndexPath) -> Void)? = nil {
        didSet {
            tableDelegate?.didSelectRow = didSelectRow
        }
    }
    
    var isEmpty: Bool {
        guard let dataSource = dataSource else {
            return true
        }
        let snapshot = dataSource.snapshot()
        return snapshot.numberOfItems == 0
    }
    
    init(rhymeListProvider: RhymeListProviderInput,
         imageDownloader: ImageDownloaderInput,
         favouritesProvider: FavouritesProviderInput) {
        self.rhymeListProvider = rhymeListProvider
        self.imageDownloader = imageDownloader
        self.favouritesProvider = favouritesProvider
    }
    
    func setup(tableView: UITableView) {
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.cellReuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 85
        
        self.tableView = tableView
        dataSource = makeDataSource()
        dataSource?.defaultRowAnimation = .fade
        tableDelegate = Delegate(dataSource: dataSource)
        tableDelegate?.didSelectRow = didSelectRow
        
        tableView.dataSource = dataSource
        tableView.delegate = tableDelegate
    }
    
    func fetch(complete: @escaping (Error?) -> Void) {
        let aggregator = Aggregator<List, FavouritesList, ConnectionError> {[weak self] result in
            switch result {
            case .success((let list, let favourites)):
                self?.handle(list: list, favourites: favourites)
                complete(nil)
            case .failure(let error):
                complete(error)
            }
        }
        
        rhymeListProvider.fetchList { result in
            aggregator.aResult = result
        }
        
        favouritesProvider.load {[weak self] (favourites) in
            if let list = self?.list {
                self?.handle(list: list, favourites: favourites)
            }
            aggregator.bResult = .success(favourites)
        }
    }
    
    func filter(favouritesOnly: Bool) {
        self.favouritesOnly = favouritesOnly
        if let list = list, let favourites = favourites {
            handle(list: list, favourites: favourites)
        }
    }
    
    private func handle(list: List, favourites: FavouritesList) {
        self.list = list
        self.favourites = favourites
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, ListViewModel>()

        let viewModels = list.results.map {
            $0.toListCellViewModel(isFavourite: favourites.contains($0.id), imageDownloader: self.imageDownloader)
        }.filter {
            self.favouritesOnly ? $0.isFavourite : true
        }
        
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(viewModels, toSection: .rhymes)
        guard let dataSource = self.dataSource else {
            assertionFailure("Data source is not setup")
            return
        }
        dataSource.apply(snapshot, animatingDifferences: UIView.areAnimationsEnabled)
    }
    
    private func makeDataSource() -> TableViewDataSource? {
        let reuseIdentifier = ListCell.cellReuseIdentifier
        guard let tableView = tableView else {
            assertionFailure("Make sure that you configure table view before creating datasource")
            return nil
        }
        return .init(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, model in
                let aCell = tableView.dequeueReusableCell(
                    withIdentifier: reuseIdentifier,
                    for: indexPath
                )
                guard let cell = aCell as? ListCell else {
                    return aCell
                }
                cell.render(model: model)
                return cell
            }
        )
    }
    
    private class Delegate: NSObject, UITableViewDelegate {
        weak var dataSource: TableViewDataSource?
        
        var didSelectRow: ((ListViewModel, IndexPath) -> Void)? = nil
        
        init(dataSource: TableViewDataSource?) {
            self.dataSource = dataSource
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            guard let dataSource = dataSource else {
                return
            }
            guard let item = dataSource.itemIdentifier(for: indexPath) else {
                return
            }
            didSelectRow?(item, indexPath)
        }
    }
}



extension ListItem {
    fileprivate func toListCellViewModel(isFavourite: Bool, imageDownloader: ImageDownloaderInput) -> ListViewModel {
        ListViewModel(id: id,
                          title: title,
                          author: author,
                          image: image.flatMap { ImagePromise(url: $0, downloader: imageDownloader) },
                          isFavourite: isFavourite)
    }
}
