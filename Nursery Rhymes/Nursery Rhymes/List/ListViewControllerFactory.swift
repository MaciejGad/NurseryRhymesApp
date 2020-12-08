import Foundation
import Models
import Connection

final class ListViewControllerFactory {
    
    func makeViewController() -> ListViewController {
        let listProvider = RhymeListProvider(baseURL: URL(string: "https://maciejgad.github.io/NurseryRhymesJSON/data/")!)
        let imageDownloader = ImageDownloader(baseURL: URL(string: "https://maciejgad.github.io/NurseryRhymesJSON/images/")!)
        let dataSource = ListDataSource(rhymeListProvider: listProvider, imageDownloader: imageDownloader)
        return ListViewController(dataSource: dataSource)
    }
}
