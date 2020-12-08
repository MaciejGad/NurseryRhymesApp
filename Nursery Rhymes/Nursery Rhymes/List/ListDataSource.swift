import Foundation
import Models
import Connection
import UIKit

fileprivate typealias TableViewDataSource = UITableViewDiffableDataSource<ListDataSource.Section, ListViewModel>

protocol ListDataSourceInput: class {
    var isEmpty: Bool { get }
    var didSelectRow: ((ListViewModel, IndexPath) -> Void)? { get set }
    func setup(tableView: UITableView)
    func fetch(complete: @escaping (Result<List, ConnectionError>) -> Void)
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
    
    init(rhymeListProvider: RhymeListProviderInput, imageDownloader: ImageDownloaderInput) {
        self.rhymeListProvider = rhymeListProvider
        self.imageDownloader = imageDownloader
    }
    
    func setup(tableView: UITableView) {
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.cellReuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 85
        
        self.tableView = tableView
        dataSource = makeDataSource()
        tableDelegate = Delegate(dataSource: dataSource)
        tableDelegate?.didSelectRow = didSelectRow
        
        tableView.dataSource = dataSource
        tableView.delegate = tableDelegate
    }
    
    func fetch(complete: @escaping (Result<List, ConnectionError>) -> Void) {
        rhymeListProvider.fetchList {[weak self] result in
            if case let .success(list) = result {
                self?.handle(success: list)
            }
            complete(result)
        }
    }
    
    private func handle(success list: List) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ListViewModel>()

        let viewModels = list.results.map {
            $0.toListCellViewModel(isFavourite: false, imageDownloader: self.imageDownloader)
        }
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(viewModels, toSection: .rhymes)
        dataSource?.apply(snapshot, animatingDifferences: true)
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
    
    fileprivate class Delegate: NSObject, UITableViewDelegate {
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
