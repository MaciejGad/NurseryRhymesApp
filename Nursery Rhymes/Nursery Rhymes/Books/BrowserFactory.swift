import Foundation
import SafariServices

final class BrowserFactory {
    func makeViewController(url: URL) -> SFSafariViewController {
        let vc = SFSafariViewController(url: url)
        vc.preferredBarTintColor = .systemBackground
        vc.preferredControlTintColor = .systemOrange
        return vc
    }
}
