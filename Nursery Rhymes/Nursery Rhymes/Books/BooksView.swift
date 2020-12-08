import Foundation

import UIKit

final class BooksView: UIView {
    let header = UILabel()
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        backgroundColor = .systemBackground
        header.translatesAutoresizingMaskIntoConstraints = false
        header.text = "Books"
        header.font = UIFont(name: "Zapfino", size: 15)
        header.textAlignment = .center
        header.textColor = .systemGray
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        tableView.tableFooterView = UIView()
        makeConstraints()
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    @available(*, unavailable, message: "init(coder:) has not been implemented, use  init(frame:) intead")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
