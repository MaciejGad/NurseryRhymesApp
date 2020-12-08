import Foundation
import UIKit

final class ListView: UIView {
    let header = UILabel()
    let tableView = UITableView()
    let refreshController = UIRefreshControl()
    let loaderView = LoaderView()
    let errorView = ErrorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func showLoader() {
        errorView.isHidden = true
        loaderView.isHidden = false
        loaderView.loader.startAnimating()
    }
    
    func showError(error: Error) {
        loaderView.isHidden = true
        //In real-life app I should better format the error message to be more readable for user
        errorView.titleLabel.text = "Error: \(error.localizedDescription)"
        errorView.isHidden = false
        refreshController.endRefreshing()
    }
    
    func successLoading() {
        errorView.isHidden = true
        loaderView.isHidden = true
        refreshController.endRefreshing()
    }

    private func setup() {
        backgroundColor = .systemBackground
        header.translatesAutoresizingMaskIntoConstraints = false
        header.text = "Nursery Rhymes"
        header.font = UIFont(name: "Zapfino", size: 15)
        header.textAlignment = .center
        header.textColor = .systemGray
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        tableView.addSubview(refreshController)
        tableView.separatorStyle = .none
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loaderView)
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorView.isHidden = true
        addSubview(errorView)
        makeConstraints()
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            loaderView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50),
            errorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50),
            errorView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.4)
        ])
    }
    
    @available(*, unavailable, message: "init(coder:) has not been implemented, use  init(frame:) intead")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#if PREVIEW && canImport(SwiftUI)
import SwiftUI

struct ListViewPreview: PreviewProvider {
    static var previews: some SwiftUI.View {
        Group {
            ListView()
                .preview()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
                .previewDisplayName("Light mode")
            ListView()
                .preview()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark mode")
        }
    }
}


#endif
