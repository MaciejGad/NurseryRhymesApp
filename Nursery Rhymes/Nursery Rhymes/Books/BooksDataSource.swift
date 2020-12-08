import Foundation
import UIKit

fileprivate typealias TableViewDataSource = UITableViewDiffableDataSource<BooksDataSource.Section, BookViewModel>

protocol BooksDataSourceInput: class {
    var didSelectRow: ((BookViewModel, IndexPath) -> Void)? { get set }
    func setup(tableView: UITableView)
    func showBooks()
}

final class BooksDataSource: BooksDataSourceInput {
    enum Section: CaseIterable {
        case books
    }
    
    private let books: [BookViewModel]
    
    private var dataSource: TableViewDataSource?
    private var tableView: UITableView?
    private var tableDelegate: Delegate?
    
    var didSelectRow: ((BookViewModel, IndexPath) -> Void)? {
        didSet {
            tableDelegate?.didSelectRow = didSelectRow
        }
    }
    
    init(books: [BookViewModel]) {
        self.books = books
    }

    func setup(tableView: UITableView) {
        tableView.register(BookCell.self, forCellReuseIdentifier: BookCell.cellReuseIdentifier)
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
    
    func showBooks() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, BookViewModel>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(books, toSection: .books)
        dataSource?.apply(snapshot, animatingDifferences: false)

    }
    
    private func makeDataSource() -> TableViewDataSource? {
        let reuseIdentifier = BookCell.cellReuseIdentifier
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
                guard let cell = aCell as? BookCell else {
                    return aCell
                }
                cell.render(model: model)
                return cell
            }
        )
    }
    
    private class Delegate: NSObject, UITableViewDelegate {
        weak var dataSource: TableViewDataSource?
        
        var didSelectRow: ((BookViewModel, IndexPath) -> Void)? = nil
        
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
